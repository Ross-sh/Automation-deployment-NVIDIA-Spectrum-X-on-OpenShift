## Ansible Role: NVIDIA Maintenance Operator - openshift_nvidia_maitenance_operator

* Namespace: nvidia-maintenance-operator
* Role: Automates safe node maintenance workflows.
* Impact: Coordinates node cordon and drain operations to protect running workloads whenever network drivers, GPU drivers, or low-level NIC firmware updates are initiated.

## 🌲 Role Structure
```
roles/openshift_nvidia_maitenance_operator
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_nv_mitenance_config.yml
    ├── create_nv_mitenance_group.yml
    ├── create_nv_mitenance_ns.yml
    └── create_nv_mitenance_subscription.yml
```

## ⚙️ Role Variables
```
operator_namespace: nvidia-maintenance-operator
operator_channel: v0.2
operator_name: nvidia-maintenance-operator
operator_source: certified-operators
operator_source_namespace: openshift-marketplace
starting_csv: nvidia-maintenance-operator.v0.2.3
nvidia_maintenance_install_plan_approval: Automatic
```

## How to run
From the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/deploy_maitenance.yml
```
or
```
ansible-playbook -i playbooks/deploy_maitenance.yml
```
