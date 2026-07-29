Ansible Role:  openshift_rdma
=========

In multi-plane / multi-rail OpenShift deployments, host network interfaces (e.g., eth0, eth1) can get assigned randomly across node reboots.

Role Variables
--------------
```
udv_gpuid: "10de:2335"
udv_nicid: "15b3:a2dc"
udv_persist_name: 70-persistent-net.rules
udv_role: worker
nodename: dell-h200-2
udv_mc_name: 99-machine-config-udev-network
```

## 🌲 Role Structure

How to run
----------------

