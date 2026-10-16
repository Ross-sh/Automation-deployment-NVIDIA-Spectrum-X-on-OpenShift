## Ansible Role: LLDP MachineConfig - lldp_machineconfig

Enables the native `lldpad` LLDP agent that RHCOS ships in its base image, via a `MachineConfig`, instead of running a separate `lldpd` container as a privileged, host-networked DaemonSet.

### Background

[RFE-5601](https://redhat.atlassian.net/browse/RFE-5601) requested native LLDP support on OpenShift nodes for cabling/topology verification on Spectrum-X's spine-leaf fabric. [OCPSTRAT-2580](https://redhat.atlassian.net/browse/OCPSTRAT-2580) added the `lldpad` package to the RHCOS base image (via `fcoe-utils`, tracked in COS-3875) — the service ships on the node but is **not enabled by default**, so it only needs to be started, which is exactly what a `MachineConfig` is for.

This role renders a `MachineConfig` that enables `lldpad.service` via Ignition. No image build, namespace, ServiceAccount, or privileged SCC is required.

### Version requirements

`lldpad` is available:
- By default from **OCP 4.22+**
- On **4.19/4.20/4.21** once the cluster has picked up the RHEL 9.6 z-stream build `9.6.20260408-0` or later

This repo does not support OCP 4.18 and below. The role queries `ClusterVersion` and fails with a clear message if the cluster's major.minor version is below `lldp_min_version` (default `4.19`). This is a coarse major.minor check — on 4.19-4.21 confirm the node's RHCOS z-stream actually includes `lldpad` before relying on it.

### Caveat: bonded interfaces and br-ex

[OCPBUGS-63650](https://redhat.atlassian.net/browse/OCPBUGS-63650) documented that enabling LLDP on a **bond** interface via NMstate/NNCP could corrupt `br-ex` on reboot, because `configure-ovs.sh` didn't propagate the `connection.lldp` setting correctly to the OVS phys interface. This was fixed upstream in `openshift/machine-config-operator#6073` (merged into `release-4.22`, backported to `release-4.21`).

This role only enables the `lldpad.service` systemd unit — by default `lldpad` runs RX/TX on all interfaces, it does not itself touch bond/br-ex configuration. This is safe for Spectrum-X's east/west Mellanox NICs, which are not bonded and not part of the `br-ex` mesh. If LLDP is also needed on a bonded management/br-ex link on a cluster older than the MCO fix above, enable it on the bond's **member links**, not on the bond interface itself.

## 🌲 Role Structure
```
roles/lldp_machineconfig
├── defaults
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
└── templates
    └── lldp_machineconfig.yml
```

## ⚙️ Role Variables
```
node_role: worker
lldp_min_version: "4.19"
```

## How to run
From the project root directory run:
```
ansible-navigator run -m stdout playbooks/deploy_lldp_machineconfig.yml
```
or
```
ansible-playbook playbooks/deploy_lldp_machineconfig.yml
```
