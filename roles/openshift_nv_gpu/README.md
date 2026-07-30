## Ansible Role: NVIDIA GPU Operator - openshift_nv_gpu

* Namespace: nvidia-gpu-operator
* Role: Manages containerized GPU drivers, CUDA runtimes, Container Toolkit, and DCGM exporter (NVIDIA Data Center GPU Manager (DCGM) is a suite of enterprise tools used to manage, monitor, and troubleshoot NVIDIA GPUs at scale).
* Spectrum-X Requirement: Deploys nvidia-peermem, the kernel module required for GPUDirect RDMA (GDR). This connects the active GPU driver with the underlying MOFED RDMA stack to allow ConnectX SuperNICs to write directly to GPU High Bandwidth Memory (HBM) over PCIe.

## 🌲 Role Structure
```
roles/openshift_nv_gpu
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_gpu_group.yml
    ├── create_gpu_namespace.yml
    ├── create_gpu_subscription.yml
    └── gpu_cluster_policy.yml
```

## ⚙️ Role Variables
```
gpu_operator_channel: "stable"
gpu_operator_namespace: "nvidia-gpu-operator"
gpo_kernelmodtype: open
gpo_rdma_enabled: true
gpo_gdrcopy_enabled: true
nv_gpu_install_plan: Automatic
nv_gpu_src: certified-operators
nv_gpu_src_nms: openshift-marketplace
nv_gpu_sub_name: gpu-operator-certified
gpu_policy_name: gpu-cluster-policy
gds_image: nvidia-fs
gds_repo: "nvcr.io/nvidia/cloud-native"
gds_version: "2.26.6"
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/deploy_gpu.yml
```
or
```
ansible-playbook -i playbooks/deploy_gpu.yml
```
