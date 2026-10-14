#!/bin/bash
#
# Disable PCIe ACS on every device that supports it, so GPU<->NIC peer-to-peer DMA
# (GPUDirect RDMA) is not redirected up through the PCIe root complex.
#
# Uses the setpci method, which is vendor-neutral.
# GB300 change: use `lspci -D` (domain-qualified BDF). GB300 spreads the ConnectX-8
# SuperNICs and GPUs across many PCI domains (0000/0002/0008/0018/...).

PLATFORM=$(dmidecode --string system-product-name 2>/dev/null || echo "Unknown")
logger "dis_acs: PLATFORM=${PLATFORM}"

# must be root to access extended PCI config space
if [ "$EUID" -ne 0 ]; then
    logger "dis_acs: ERROR must be run as root"
    exit 1
fi

# setpci is provided by pciutils (present in RHCOS)
if ! command -v setpci &>/dev/null; then
    logger "dis_acs: ERROR setpci not found (pciutils)"
    exit 1
fi

DISABLED_COUNT=0
for BDF in $(lspci -D | awk '{print $1}'); do
    # skip devices that do not expose an ACS capability
    setpci -v -s "${BDF}" ECAP_ACS+0x6.w >/dev/null 2>&1 || continue

    # clear the ACS Control register -> all P2P allowed directly (DirectTrans)
    if ! setpci -v -s "${BDF}" ECAP_ACS+0x6.w=0000 >/dev/null 2>&1; then
        logger "dis_acs: ERROR writing ACS ctrl on ${BDF}"
        continue
    fi

    NEW_VAL=$(setpci -s "${BDF}" ECAP_ACS+0x6.w)
    if [ "${NEW_VAL}" != "0000" ]; then
        logger "dis_acs: FAILED to clear ACS ctrl on ${BDF} (=${NEW_VAL})"
        continue
    fi
    DISABLED_COUNT=$((DISABLED_COUNT + 1))
done

logger "dis_acs: disabled ACS on ${DISABLED_COUNT} device(s)"
exit 0
