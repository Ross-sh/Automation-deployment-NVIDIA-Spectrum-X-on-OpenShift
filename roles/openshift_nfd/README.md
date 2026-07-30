Ansible Role: Node Feature Discovery (NFD) Operator openshift_nfd
=========

Deploy and configure OpenShift NFD Operator

* Namespace: openshift-nfd
* Role: Scans host hardware at boot and periodically applies Kubernetes node labels based on PCI vendor and device IDs.
* Key Labels:
  * feature.node.kubernetes.io/pci-10de.present=true (NVIDIA GPUs)
  * feature.node.kubernetes.io/pci-15b3.present=true (NVIDIA/Mellanox ConnectX-7/8 SuperNICs & BlueField-3 DPUs)
* Impact: Acts as the deployment selector for the GPU and Network operators.


## ⚙️ Role Variables
```
nfd_namespace: "openshift-nfd"
nfd_channel: "stable"
```

## 🌲 Role Structure
```
roles/openshift_nfd/
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_nfd_instance.yml
    ├── create_nfd_namespace.yml
    ├── create_nfd_oprgroup.yml
    └── create_nfd_subscription.yml
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/deploy_nfd.yml/ # # If you have preconfigured image with all required modules to run ansible
```
or
```
ansible-playbook -i playbooks/deploy_nfd.yml
```
