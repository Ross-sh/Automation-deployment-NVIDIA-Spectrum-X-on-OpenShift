## Ansible Role: NVIDIA Network Operator - openshift_nno

* Namespace: nvidia-network-operator
* Role: Orchestrates the Spectrum-X networking software stack:
  * Injects containerized MOFED (Mellanox OFED) kernel drivers into RHCOS.
  * Deploys the RDMA Shared Device Plugin and SR-IOV CNI.
  * Deploys NV-IPAM for parallel IP address allocation across multi-rail GPU networks.

Because we have already installed the Node Feature Discovery (NFD) and the SR-IOV Network Operator, The NVIDIA Network Operator will automatically detect the presence of the SR-IOV Network Operator on OpenShift and integrate with it to manage NVIDIA/Mellanox networking hardware (like ConnectX NICs or BlueField DPUs).



## 🌲 Role Structure
```
roles/openshift_nno
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_nfs_pvc.yml
    ├── create_nfs_pv.yml
    ├── create_nno_group.yml
    ├── create_nno_namespace.yml
    ├── create_nno_nicclusterpolicy.yml
    └── create_nno_subscription.yml
```

## ⚙️ Role Variables
```
pv_name: "nfs-nic-fw-storage"
pvc_namespace: "nvidia-network-operator"
storage_class: "nfs"
storage_size: "10Gi"
access_mode: "ReadWriteMany"
nfs_server: "nvd-srv-39.nvidia.eng.rdu2.dc.redhat.com"
pvc_name: "nic-fw-storage-pvc"
storage_name: "nic-fw-storage"
nno_namespace: nvidia-network-operator
nno_version: v26.1
nno_driver_version: doca3.2.0-25.10-1.2.8.0-2
ncp_name: nic-cluster-policy
nc_deamon_name: nic-configuration-daemon
nco_deamon_image: nic-configuration-operator-daemon
nv_repository: "nvcr.io/nvidia/mellanox"
nco_name: nic-configuration-operator
nvpam_image: nvidia-k8s-ipam
doca_version: doca3.3.0-26.01-1.0.0.0-0
spct_operator_image: spectrum-x-operator
ofed_driver_image: doca-driver
nvidia_net_operator_approval_strategy: Automatic
nvidia_net_operator_source: certified-operators
nvidia_net_operator_source_namespace: openshift-marketplace
```

### Note
To successfully install and configure all components required by Spectrum-X within the NVIDIA Network Operator, we must configure shared storage. In our setup, we utilize NFS storage, which is dynamically provisioned by the current playbook.

## How to run
```
ansible-navigator run -m stdout playbooks/deploy_nno.yml
```
or
```
ansible-playbook -i playbooks/deploy_nno.yml
```

