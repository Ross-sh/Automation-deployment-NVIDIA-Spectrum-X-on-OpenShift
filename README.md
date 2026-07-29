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
