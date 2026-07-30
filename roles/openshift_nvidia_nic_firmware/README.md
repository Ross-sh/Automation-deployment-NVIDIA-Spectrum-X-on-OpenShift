## Ansible Role: NIC Configuration Operator - openshift_nvidia_nic_firmware

* Namespace: Integrated within nvidia-network-operator
* Role: Configures low-level hardware parameters directly on ConnectX SuperNIC and BlueField DPU ASICs.
* Key Tasks: Enforces link speed, PFC/ECN congestion profiles, firmware versions, PCIe boot settings, and custom interface renaming schemas (NicInterfaceNameTemplate). Operates under the protective drain/cordon umbrella provided by the Maintenance Operator.

NVIDIA NIC Configuration Operator provides Kubernetes API(Custom Resource Definition) to allow FW configuration on Nvidia NICs in a coordinated manner. It deploys, based on settings in the NicClusterPolicy, a configuration daemon on each of the desired nodes to configure Nvidia NICs there. NVIDIA NIC Configuration Operator uses the Maintenance Operator to prepare a node for maintenance before the actual configuration.

In this playbook, we will install and configure the NIC firmware, the NicFirmwareTemplate and NicConfigurationTemplate.

## 🌲 Role Structure
```
roles/openshift_nvidia_nic_firmware
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_fw_source.yml
    ├── create_nic_config_template.yml
    └── create_nic_fw_template.yml
```

## ⚙️ Role Variables
```
fwsource_name: "spc-x-doca-pcc"
nv_namespace: "nvidia-network-operator"
bfb_url_src: "https://content.mellanox.com/BlueField/FW-Bundle/bf-fwbundle-3.3.0-202_26.01-prod.bfb"
nic_type: "a2dc"
link_type: "Ethernet"
spctrx_opt_ver: "RA2.1"
num_vfs: "1"
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/config_nic_fw.yml
```
or
```
ansible-playbook -i playbooks/config_nic_fw.yml
```
