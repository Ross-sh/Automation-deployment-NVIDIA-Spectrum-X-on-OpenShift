## Ansible Role: Physical Rail Interface Attributes - ph_rail_interface

The configuration of physical rail attributes is executed through a dual-layer approach: initially at the host level using NodeNetworkConfigurationPolicy (NNCP) and subsequently at the virtual function layer via SriovNetworkNodePolicy declarations. For every individual rail in the fabric (typically spanning indices 0–7), a dedicated NodeNetworkConfigurationPolicy must be defined.

## 🌲 Role Structure
```
roles/ph_rail_interface
├── defaults
│   └── main.yml
├── files
├── outputs
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── nncp_mtu_rail.j2
    └── snnp_eth_railx.j2
```

## ⚙️ Role Variables
```
node_role: "worker"
mtu_param: "9216"
type: "ethernet"
sriov_namespace: "openshift-sriov-network-operator"
devicetype: "netdevice"
eswitchmode: "switchdev"
isrdma: true
linktype: ETH
numvfs: 1
priority: 99
ipam_type: "nv-ipam"
pooltype: "cidrpool"
metaplg_type: "rdma"
networknamespace: "default"
openshift_network_rails:
  - eth_rail0
  - eth_rail1
  - eth_rail2
  - eth_rail3
  - eth_rail4
  - eth_rail5
  - eth_rail6
  - eth_rail7
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/ph_rail_config.yml
```
or
```
ansible-playbook -i playbooks/ph_rail_config.yml
```
