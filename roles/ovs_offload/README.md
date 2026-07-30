## Ansible Role: OVS Offload - ovs_offload

NVIDIA leverages ASAP² (Accelerated Switching and Packet Processing) technology to offload Open vSwitch (OVS) data-plane forwarding rules into the silicon of ConnectX SuperNICs or BlueField DPUs for line-rate hardware performance.

Implementing this functionality within an OpenShift environment requires no additional modification to the NVIDIA Network Operator. Rather, you must mandate that the SR-IOV Network Operator migrates the embedded switch (eSwitch) on the network adapter. Specifically, you will transition the eSwitch from the standard legacy state into the accelerated switchdev operational mode. 

## 🌲 Role Structure
```
roles/ovs_offload
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── sriov_dis_mlnx.yml
    └── sriov_network_pool_config_offload.yml
```

## ⚙️ Role Variables
```
node_role: worker
ovs_off_nms: openshift-sriov-network-operator
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/config_ovs_off.yml
```
or
```
ansible-playbook -i playbooks/config_ovs_off.yml
```
