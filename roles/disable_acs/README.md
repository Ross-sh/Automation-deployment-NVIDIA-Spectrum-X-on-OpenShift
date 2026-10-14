## Ansible Role: Disable PCIe ACS - disable_acs

GPUDirect RDMA relies on peer-to-peer (P2P) DMA between each GPU and its ConnectX-8 SuperNIC. PCIe ACS (Access Control Services) on the PCIe bridges redirects P2P transactions up through the root complex, defeating direct GPU↔NIC DMA.

Disabling ACS in the BIOS requires disabling Virtualization Technology, which prevents the host from running Sandboxed and Confidential containers. Instead, this role deploys a `MachineConfig` that drops a vendor-neutral `setpci` script at `/usr/local/bin/dis_acs.sh` and a systemd oneshot (`dis-acs.service`) that runs it on **every boot**, clearing the ACS Control register on every capable device so P2P takes the direct path (`DirectTrans`).

The script iterates `lspci -D` (domain-qualified BDF) because platforms such as GB300 spread the SuperNICs and GPUs across many PCI domains (`0000/0002/0008/0018/...`).

An identical `MachineConfig` is applied to both the `master` and `worker` MachineConfigPools (configurable via `acs_roles`).

References:
- Red Hat KCS — [Disabling PCI ACS for any device](https://access.redhat.com/solutions/6962227)
- NVIDIA GB300 NVL72 RoCE on OpenShift guide — section 2.1 "Disable PCIe ACS every boot"

## 🌲 Role Structure
```
roles/disable_acs
├── defaults
│   └── main.yml
├── files
│   └── dis_acs.sh
├── README.md
├── tasks
│   └── main.yml
└── templates
    └── mc_disable_acs.yml
```

## Role Variables

| Variable          | Default                      | Description                                             |
|-------------------|------------------------------|---------------------------------------------------------|
| `acs_roles`       | `[master, worker]`           | MachineConfigPool roles the MachineConfig is applied to |
| `acs_script_path` | `/usr/local/bin/dis_acs.sh`  | Path the disable-ACS script is dropped at on each node   |

## How to run
From the project root directory run the following command:
```
ansible-navigator run -m stdout playbooks/disable_acs.yml
```
or
```
ansible-playbook -i playbooks/disable_acs.yml
```

## Verification
After the affected nodes reboot (the MachineConfig triggers a rolling reboot), confirm ACS is disabled:
```
oc debug node/<node> -q -- chroot /host sh -c \
    'journalctl -u dis-acs.service | grep dis_acs | tail -2; lspci -vvv 2>/dev/null | grep -i "ACSCtl:" | head -1'
```
All redirect bits should read `-` (e.g. `SrcValid- ReqRedir- CmpltRedir- ... DirectTrans-`), confirming ACS is disabled.
