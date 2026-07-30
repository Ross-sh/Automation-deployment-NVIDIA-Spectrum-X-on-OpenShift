## Ansible Role: LLDPD Daemonset - lldp_daemonset

In high-performance networking infrastructure, LLDP (Link Layer Discovery Protocol) orchestrates the automated discovery and fabric configuration of NVIDIA Spectrum-X solutions, guaranteeing peak efficiency for large-scale AI/ML clusters.

### Note:
Although the lldpd service is included in newer versions of RHCOS, we have not yet tested it in our current automation framework.


## 🌲 Role Structure
```
roles/lldp_daemonset
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── allow_scc_lldpdaemon.yml
    ├── create_lldp_srv_acc.yml
    └── deploy_lldpdaemon.yml
```

## ⚙️ Role Variables
```
lldp_nms: "nvidia-network-operator"
lldp_image: "quay.io/rh-ee-rshaligi/sptr-x/lldpd:0.0.5" # Using preconfigured lldp image with parameters specified by NVIDIA
lldp_acc_name: lldp-acc
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/deploy_lldp_daemonset.yml
```
or
```
ansible-playbook -i playbooks/deploy_lldp_daemonset.yml
```
