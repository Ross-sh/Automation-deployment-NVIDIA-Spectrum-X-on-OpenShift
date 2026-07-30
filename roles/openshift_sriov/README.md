## Ansible Role: SR-IOV Network Operator 

* Namespace: openshift-sriov-network-operator
* Role: Configures Single Root I/O Virtualization (SR-IOV) on SuperNICs. Instantiates Virtual Functions (VFs), sets driver modes (netdevice or vfio-pci), and creates * NetworkAttachmentDefinitions (NADs).
* Impact: Delivers hardware-bypassed direct access from pods to SuperNICs for sub-microsecond latency.


## 🌲 Role Structure
```
roles/openshift_sriov
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_sriov_instance.yml
    ├── create_sriov_namespace.yml
    ├── create_sriov_opr_group.yml
    └── create_sriov_subscription.yml
```

## ⚙️ Role Variables
```
sriov_namespace: openshift-sriov-network-operator
sriov_catalog_source: redhat-operators
sriov_catalog_source_namespace: openshift-marketplace
sriov_channel: stable
node_role: worker
```
## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/deploy_sriov.yml
```
or
```
ansible-playbook -i playbooks/deploy_sriov.yml
```
