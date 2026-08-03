# OpenShift Cluster & Hardware Automation Framework

An Ansible-based automation suite designed for provisioning, configuring, and tuning low-level hardware components, specialized kernel parameters, and network operators on OpenShift Container Platform (OCP) clusters.

## 📋 Overview

This repository automates the NVIDIA Spectrum-X deployment and artificial intelligence (AI) workloads running on OpenShift. It covers everything from node-level kernel tuning (Hugepages, IOMMU, RDMA, FWCTL) to automated deployment of specialized operators (SR-IOV, GPU, NFD, NMState, NVIDIA Network Operator) and custom network setups (Spectrum-X, OVS Offload, LLDPD).

---

## 🏗 Repository Structure

The automation suite is structured logically into reusable **Roles** and task-specific **Playbooks**.

```text
.
├── playbooks/
│   ├── change_password.yml
│   ├── set_krn.yml
│   ├── openshift_rdma
│   ├── openshift_udev_create.yml
│   ├── deploy_udev.yml
│   ├── deploy_nfd.yml
│   ├── deploy_sriov.yml
│   ├── deploy_nmstate.yml
│   ├── deploy_nno.yml
│   ├── deploy_maitenance.yml
│   ├── config_nic_fw.yml
│   ├── deploy_gpu.yml
│   ├── deploy_lldp_machineconfig.yml
│   ├── config_ovs_off.yml
│   ├── ph_rail_config.yml
│   ├── config_sptrx_cni.yml
│   └── fwctl_config.yml
└── roles/
    ├── openshift_scp
    ├── openshift_krn
    ├── openshift_udev
    ├── openshift_nfd
    ├── openshift_sriov
    ├── openshift_nmstate
    ├── openshift_nno
    ├── openshift_nvidia_maitenance_operator
    ├── openshift_nvidia_nic_firmware
    ├── openshift_nv_gpu
    ├── lldp_machineconfig
    ├── ovs_offload
    ├── ph_rail_interface
    ├── spectrum_x_cni
    └── fwctl_krn_module
├── vars/
│   ├── ocp_connect.yml
```

## 🛠 General variable, Modules, Playbooks, and Roles Map


| Module / Function           | Playbook                                 | Role(s)                              | CRD / Sub-components                                     |
|-----------------------------|------------------------------------------|--------------------------------------|----------------------------------------------------------|
| [User Management](roles/openshift_scp/)             | change_password.yml                      | openshift_scp                        | Set core user password for troubleshooting               |
| [Kernel Tuning](roles/openshift_krn/)               | set_krn.yml                              | openshift_krn                        | Set Hugepages and IOMMU offset                           |
| [RDMA Subsystem](roles/openshift_rdma/)              | openshift_rdma                           | openshift_rdma                       | Enable RDMA subsystem namespace awareness                |
| [UDEV Rules](roles/openshift_udev/)                  | openshift_udev_create.yml   deploy_udev.yml | openshift_udev / deploy_udev       | Set UDEV rules for Rail Device Names                     |
| [NFD Operator](roles/openshift_nfd/)                | deploy_nfd.yml                           | openshift_nfd                        | Install and configure Node Feature Discovery Operator    |
| [SRIOV Operator](roles/openshift_sriov/)              | deploy_sriov.yml                         | openshift_sriov                      | Install and configure SR-IOV Network Operator            |
| [NMState Operator](roles/openshift_nmstate)            | deploy_nmstate.yml                       | openshift_nmstate                    | Install and configure Kubernetes NMState Operator        |
| [NVIDIA Network Operator](roles/openshift_nno/)     | deploy_nno.yml                           | openshift_nno                        | Install NNO, apply NNCP for Spectrum-X                   |
| [NVIDIA Maintenance Operator](roles/openshift_nvidia_maitenance_operator/) | deploy_maitenance.yml                    | openshift_nvidia_maitenance_operator | Install and configure NVIDIA Maintenance Operator        |
| [NIC Firmware](roles/openshift_nvidia_nic_firmware)                | config_nic_fw.yml                        | openshift_nvidia_nic_firmware        | Manage NicFirmwareTemplate & NicConfigurationTemplate    |
| [NVIDIA GPU Operator](roles/openshift_nv_gpu/)         | deploy_gpu.yml                           | openshift_nv_gpu                     | Install and configure NVIDIA GPU Operator                |
| [LLDP MachineConfig](roles/lldp_machineconfig/)      | deploy_lldp_machineconfig.yml             | lldp_machineconfig                   | Enable native RHCOS `lldpad` service for link discovery |
| [OVS Offload](roles/ovs_offload)                 | config_ovs_off.yml                       | ovs_offload                          | Configure Open vSwitch (OVS) Hardware Offload            |
| [Physical Rail Interfaces](roles/ph_rail_interface/)    | ph_rail_config.yml                       | ph_rail_interface                    | Configure physical rail interface attributes             |
| [Spectrum-X CNI](roles/spectrum_x_cni/)              | config_sptrx_cni.yml                     | spectrum_x_cni                       | Configure Spectrum-X CNI and OVSNetwork Custom Resources |
| [FWCTL Module](roles/fwctl_krn_module/)                | fwctl_config.yml                         | fwctl_krn_module                     | Configure FWCTL Kernel Module                            |

* __Global variables located within the vars directory__

## ⚙️ General Variables
```
k8s_kubeconfig: "path to kubeconfig file"
ocp_api_url: "https://api.to_yor_cluster:6443"
```


🚀 Prerequisites

Before running any playbooks, ensure the following requirements are met:

* Ansible: ansible-core >= 2.14
* OpenShift CLI: oc tool installed and authenticated (oc login) to the target OCP cluster with cluster-admin privileges.
* Python Dependencies
  * kubernetes
  * PyYAML
* Network Access: Direct API access to the OpenShift master node API endpoint.
