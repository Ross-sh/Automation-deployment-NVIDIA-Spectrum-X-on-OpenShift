## Ansible Role: FWCTL Kernel Module - fwctl_krn_module

NVIDIA is programmatically transitioning away from legacy, highly privileged PCI access mechanisms (such as mst or mlx_core). In their place, the fwctl (Firmware Control) Linux kernel subsystem has been adopted as the primary interface for secure hardware management.
The NIC Configuration Daemon utilizes this subsystem to orchestrate safe interactions with ConnectX/BlueField NVRAM. By leveraging standard character devices (/dev/fwctl*), the platform eliminates the need for risky direct memory mapping during firmware operations.


## 🌲 Role Structure
```
roles/fwctl_krn_module
├── defaults
│   └── main.yml
├── files
│   └── fwctl_script.sh
├── README.md
├── tasks
│   ├── main.yml
│   └── main.yml.BACK
└── templates
    ├── fwctl_script.sh.j2
    ├── load-fwctl.sh.j2
    └── mc_load_fwctl.yml
```


## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/fwctl_config.yml
```
or
```
ansible-playbook -i playbooks/fwctl_config.yml
```
