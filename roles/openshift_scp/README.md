## Ansible Role: OpenShift SCP (Set Core User Password for Troubleshooting) - (Optional)

This section is completely optional but might be useful in the event network connectivity is lost to one of the OpenShift nodes. Here we will configure a password for the core user so we can login via the console if necessary.
The first step is to assign a hash password to the core user variable using the mkpasswd utlity. In our example we are passing in a password as the password. Choose a password that is appropriate for the organization's password policy.

## 🌲 Directory Structure
```text
.
oles/openshift_scp/
├── README.md              # Role documentation
├── defaults/
│   └── main.yml          # Default role variables
├── tasks/
│   └── main.yml          # Main entry point for role execution
└── vars/
    └── main.yml          # Role-specific internal variables
```

## ⚙️ Role Variables

### Required Variables
* node_role: worker
* core_password: "Your Paassword"

## How to run
from the project root directory run the following command
Bash

```
ansible-navigator run -m stdout playbooks/change_password.yml  # If you have preconfigured image with all required modules to run ansible
```
or
```
ansible-playbook -i playbooks/change_password.yml
```

