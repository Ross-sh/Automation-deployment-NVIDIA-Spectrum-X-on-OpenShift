#!/bin/bash
#
# Disable PCIe ACS on every device that supports it, so GPU<->NIC peer-to-peer DMA
# (GPUDirect RDMA) is not redirected up through the PCIe root complex.
#
# Uses the setpci method, which is vendor-neutral.
# GB300 change: use `lspci -D` (domain-qualified BDF). GB300 spreads the ConnectX-8
# SuperNICs and GPUs across many PCI domains (0000/0002/0008/0018/...).
#
# Runs once at boot (before crio) and then periodically from disable-acs.timer.
# ACS control registers are restored to their stock (ACS-on) state by a device
# reset / FLR, so the periodic run re-applies the fix if a device drifts back.
# To keep the journal clean on the steady-state periodic runs, a device is only
# written to (and logged) when it is found with ACS still enabled; devices that
# are already cleared are skipped silently.

PLATFORM=$(dmidecode --string system-product-name 2>/dev/null || echo "Unknown")

# must be root to access extended PCI config space
if [ "$EUID" -ne 0 ]; then
    echo "disable-acs: ERROR must be run as root"
    exit 1
fi

# setpci is provided by pciutils (present in RHCOS)
if ! command -v setpci &>/dev/null; then
    echo "disable-acs: ERROR setpci not found (pciutils)"
    exit 1
fi

CAPABLE_COUNT=0    # devices that expose an ACS capability
CLEARED_COUNT=0    # devices we had to (re-)clear this run (drifted back to ACS-on)
FAILED_COUNT=0     # devices where the write/verify did not take

for BDF in $(lspci -D | awk '{print $1}'); do
    # ACS Capability register: which control bits are implemented (and writable).
    # Devices without an ACS capability make this read fail -> skip them.
    CAP=$(setpci -s "${BDF}" ECAP_ACS+0x4.w 2>/dev/null) || continue
    [ -z "${CAP}" ] && continue
    CAPABLE_COUNT=$((CAPABLE_COUNT + 1))

    # Only the implemented capability bits are writable in the Control register;
    # hardwired / reserved bits may read back non-zero and must not be verified.
    # Low 7 bits are the ACS control-enable flags (V/B/R/C/U/E/T); the capability
    # register's high bits are the Egress Control Vector size, not control flags.
    MASK=$(( 0x${CAP} & 0x7f ))

    CUR=$(setpci -s "${BDF}" ECAP_ACS+0x6.w 2>/dev/null)
    # Already cleared (no enforcement bits set among the writable ones) -> skip quietly.
    if [ $(( 0x${CUR:-0} & MASK )) -eq 0 ]; then
        continue
    fi

    # Clear the ACS Control register -> all P2P allowed directly (DirectTrans).
    if ! setpci -s "${BDF}" ECAP_ACS+0x6.w=0000 >/dev/null 2>&1; then
        echo "disable-acs: ERROR writing ACS ctrl on ${BDF} (was ${CUR})"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        continue
    fi

    # Verify only the writable bits were cleared; ignore hardwired/reserved bits.
    NEW_VAL=$(setpci -s "${BDF}" ECAP_ACS+0x6.w 2>/dev/null)
    if [ $(( 0x${NEW_VAL:-ffff} & MASK )) -ne 0 ]; then
        echo "disable-acs: FAILED to clear ACS ctrl on ${BDF} (=${NEW_VAL}, mask=${CAP})"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        continue
    fi

    echo "disable-acs: cleared ACS on ${BDF} (was ${CUR})"
    CLEARED_COUNT=$((CLEARED_COUNT + 1))
done

# No ACS-capable devices at all means setpci never wrote anything: on target
# hardware this never happens, so treat it as a failure rather than silent success.
if [ "${CAPABLE_COUNT}" -eq 0 ]; then
    echo "disable-acs: ERROR no ACS-capable devices found (PLATFORM=${PLATFORM})"
    exit 1
fi

# Any write/verify failure is a real regression -> fail the unit so status/alerts catch it.
if [ "${FAILED_COUNT}" -ne 0 ]; then
    echo "disable-acs: ERROR ${FAILED_COUNT} device(s) still have ACS enabled (PLATFORM=${PLATFORM})"
    exit 1
fi

# Only log on the runs that actually changed something (boot, or a post-reset drift).
# Steady-state periodic runs find everything already cleared and stay silent.
if [ "${CLEARED_COUNT}" -ne 0 ]; then
    echo "disable-acs: disabled ACS on ${CLEARED_COUNT}/${CAPABLE_COUNT} device(s) (PLATFORM=${PLATFORM})"
fi

exit 0
