## Ansible Role: Kubernetes NMState Operator - openshift_nmstate

* Namespace: openshift-nmstate
* Role: Declaratively configures host-level networking (node interfaces, Linux bonding, MTU 9000+, static routes) on RHCOS via NodeNetworkConfigurationPolicy (NNCP) CRs.
* Impact: Prepares host primary interfaces and L2/L3 bonding before secondary container networking is attached.

## 🌲 Role Structure
```
roles/openshift_nmstate
├── defaults
│   └── main.yml
├── files
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── create_nmstate_group.yml
    ├── create_nmstate_instance.yml
    ├── create_nmstate_namespace.yml
    └── create_nmstate_subscription.yml
```

## ⚙️ Role Variables
```
nmstate_namespace: openshift-nmstate
nmstate_catalog_source: redhat-operators
nmstate_catalog_source_namespace: openshift-marketplace
nmstate_channel: stable
```

## How to run
```
ansible-navigator run -m stdout playbooks/deploy_nmstate.yml
```
or
```
ansible-playbook -i playbooks/deploy_nmstate.yml
```
