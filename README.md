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
│   ├── deploy_lldp_daemonset.yml
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
    ├── lldp_daemonset
    ├── ovs_offload
    ├── ph_rail_interface
    ├── spectrum_x_cni
    └── fwctl_krn_module

| Module / Function           | Playbook                                 | Role(s)                              | CRD / Sub-components                                     |
|-----------------------------|------------------------------------------|--------------------------------------|----------------------------------------------------------|
| User Management             | change_password.yml                      | openshift_scp                        | Set core user password for troubleshooting               |
| Kernel Tuning               | set_krn.yml                              | openshift_krn                        | Set Hugepages and IOMMU offset                           |
| RDMA Subsystem              | openshift_rdma                           | openshift_rdma                       | Enable RDMA subsystem namespace awareness                |
| UDEV Rules                  | openshift_udev_create.ymldeploy_udev.yml | openshift_udev                       | Set UDEV rules for Rail Device Names                     |
| NFD Operator                | deploy_nfd.yml                           | openshift_nfd                        | Install and configure Node Feature Discovery Operator    |
| SRIOV Operator              | deploy_sriov.yml                         | openshift_sriov                      | Install and configure SR-IOV Network Operator            |
| NMState Operator            | deploy_nmstate.yml                       | openshift_nmstate                    | Install and configure Kubernetes NMState Operator        |
| NVIDIA Network Operator     | deploy_nno.yml                           | openshift_nno                        | Install NNO, apply NNCP for Spectrum-X                   |
| NVIDIA Maintenance Operator | deploy_maitenance.yml                    | openshift_nvidia_maitenance_operator | Install and configure NVIDIA Maintenance Operator        |
| NIC Firmware                | config_nic_fw.yml                        | openshift_nvidia_nic_firmware        | Manage NicFirmwareTemplate & NicConfigurationTemplate    |
| NVIDIA GPU Operator         | deploy_gpu.yml                           | openshift_nv_gpu                     | Install and configure NVIDIA GPU Operator                |
| LLDPD Daemonset             | deploy_lldp_daemonset.yml                | lldp_daemonset                       | Deploy and configure LLDPD DaemonSet for link discovery  |
| OVS Offload                 | config_ovs_off.yml                       | ovs_offload                          | Configure Open vSwitch (OVS) Hardware Offload            |
| Physical Rail Interfaces    | ph_rail_config.yml                       | ph_rail_interface                    | Configure physical rail interface attributes             |
| Spectrum-X CNI              | config_sptrx_cni.yml                     | spectrum_x_cni                       | Configure Spectrum-X CNI and OVSNetwork Custom Resources |
| FWCTL Module                | fwctl_config.yml                         | fwctl_krn_module                     | Configure FWCTL Kernel Module                            |
