## Ansible Role: Increase memlock limit - increase_memlock

Running RDMA training jobs as a non-root user under the most restrictive OpenShift default security context requires an increased limit of pinned (locked) memory in the container engine. By default CRI-O caps `memlock`, which prevents non-root workloads from registering the memory regions RDMA needs.

This role uses the Machine Config Operator to drop a CRI-O configuration file at `/etc/crio/crio.conf.d/10-custom` that raises the `memlock` ulimit (unlimited by default, `-1:-1`) for all containers. This enables non-root users to run RDMA training jobs in the most restrictive OpenShift default security context.

An identical `MachineConfig` is applied to each MachineConfigPool role listed in `memlock_roles` (worker only by default). Applying the MachineConfig triggers a rolling reboot of the affected nodes.

References:
- Red Hat OpenShift AI docs — "Increasing the limit of pinned memory for non-root users"
- Red Hat KCS — [Set default ulimits on CRIO Using machine config](https://access.redhat.com/solutions/5425951)

## 🌲 Role Structure
```
roles/increase_memlock
├── defaults
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
└── templates
    ├── 10-custom.conf.j2
    └── mc_increase_memlock.yml
```

## Role Variables

| Variable            | Default                          | Description                                                     |
|---------------------|----------------------------------|-----------------------------------------------------------------|
| `memlock_roles`     | `[worker]`                       | MachineConfigPool roles the MachineConfig is applied to         |
| `memlock_limit`     | `-1:-1`                          | CRI-O `memlock` ulimit (soft:hard); `-1:-1` means unlimited     |
| `memlock_conf_path` | `/etc/crio/crio.conf.d/10-custom`| Path the CRI-O drop-in config is written to on each node        |

## How to run
From the project root directory run the following command:
```
ansible-navigator run -m stdout playbooks/increase_memlock.yml
```
or
```
ansible-playbook playbooks/increase_memlock.yml
```

## Verification
After the affected nodes reboot (the MachineConfig triggers a rolling reboot), confirm the ulimit is applied:
```
oc debug node/<node> -q -- chroot /host sh -c \
    'cat /etc/crio/crio.conf.d/10-custom'
```
The output should show the `default_ulimits` entry with the configured `memlock` value.

*If you overrode `memlock_conf_path`, substitute that path for `/etc/crio/crio.conf.d/10-custom` above.*
