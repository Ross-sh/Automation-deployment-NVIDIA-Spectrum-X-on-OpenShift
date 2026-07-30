## Ansible Role: Spectrum-X CNI - spectrum_x_cni

In the context of architectural deployment on OpenShift, the NVIDIA Spectrum-X solution does not consist of a standalone executable defined as the "Spectrum-X CNI."
Rather, Spectrum-X represents a highly-optimized networking stack that is programmatically orchestrated by previously deployed operators. This framework integrates the accelerated data-path capabilities of the SR-IOV CNI (utilizing BlueField-3 SuperNICs) with the distributed control-plane logic of NVIDIA NV-IPAM, NVIDIA's specialized IP Address Management solution.
Legacy IPAM plugins, including host-local and whereabouts, lack the required scalability and RoCE v2 endpoint synchronization necessary for high-density AI clusters. NV-IPAM addresses these limitations by offering deterministic, cluster-wide IP allocation engineered for Spectrum-X AI fabrics.


## 🌲 Role Structure
```
roles/spectrum_x_cni
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── cidrpool.yml.j2
    └── ovsnetwork_eth_rail.j2
```

## ⚙️ Role Variables
```
sriov_ns: openshift-sriov-network-operator
ipam_type: nv-ipam
pooltype: cidrpool
metaplg_type: rdma
networknamespace: default
cidrpool_nms: nvidia-network-operator
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
ansible-navigator run -m stdout playbooks/config_sptrx_cni.yml
```
or
```
ansible-playbook -i playbooks/config_sptrx_cni.yml
```
