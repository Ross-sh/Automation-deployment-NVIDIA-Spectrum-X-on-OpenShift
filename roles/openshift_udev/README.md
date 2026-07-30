Ansible Role: Set UDEV rules for Rail Device Names openshift_udev
=========

In multi-plane / multi-rail OpenShift deployments, host network interfaces (e.g., eth0, eth1) can get assigned randomly across node reboots.

## 🌲 Role Structure
```
roles/openshift_udev/
├── ansible-navigator.log
├── defaults
│   └── main.yml
├── files
│   └── remote-gpu-nic-rail-mapping.sh
├── README.md
├── tasks
│   └── main.yml
└── templates

roles/deploy_udev/
├── defaults
│   └── main.yml
├── files
│   └── 70-persistent-net.rules
├── README.md
├── tasks
│   └── main.yml
└── templates
    └── 99-machine-config-udev-network.yml
```
## ⚙️ Role Variables

```
udv_gpuid: "10de:2335"
udv_nicid: "15b3:a2dc"
udv_persist_name: 70-persistent-net.rules
udv_role: worker
nodename: dell-h200-2
udv_mc_name: 99-machine-config-udev-network
```

How to run
----------------
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/openshift_udev_create.yml # If you have preconfigured image with all required modules to run ansible
```
or
```
ansible-playbook -i playbooks/openshift_udev_create.yml
```

Once the script finish the operation we can continue to deploy section

```
ansible-navigator run -m stdout playbooks/deploy_udev.yml 
```
or
```
ansible-playbook -i playbooks/deploy_udev.yml
```
