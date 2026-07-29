Ansible Role:  openshift_rdma
=========

Enable RDMA device namespace separation, which is essential for proper resource isolation in containerized environments.

## ⚙️ Role Variables

```
node_role: worker
```

## 🌲 Role Structure
```
.
roles/openshift_rdma/
├── README.md             # Role documentation
├── defaults/
│   └── main.yml          # Default role variables
├── tasks/
│   └── main.yml          # Main entry point for role execution
└── vars/
    └── main.yml          # Role-specific internal variables
```
## How to run
from the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/set_rdma.yml # # If you have preconfigured image with all required modules to run ansible
```
or
```
ansible-playbook -i playbooks/set_rdma.yml
```





