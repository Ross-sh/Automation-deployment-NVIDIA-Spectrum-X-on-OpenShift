## Ansible Role: Openshift Kernel tuning openshift_krn

Tuning an OpenShift cluster for NVIDIA Spectrum-X (an AI-optimized Ethernet networking platform leveraging BlueField-3 SuperNICs or ConnectX-8/ConnectX-7 adapters with adaptive routing and congestion control) requires a combination of OpenShift Worker Nodes Tuning.
Spectrum-X relies heavily on RDMA over Converged Ethernet (RoCE), packet load balancing (software/hardware PLB), and precise congestion control (DOCA SPC-X CC).
High-performance AI training workloads require low-latency kernel behavior, optimized memory management, and high network buffer capacities.

## 🌲 Role Structure
```
.
roles/openshift_scp/
├── README.md             # Role documentation
├── defaults/
│   └── main.yml          # Default role variables
├── tasks/
│   └── main.yml          # Main entry point for role execution
└── vars/
    └── main.yml          # Role-specific internal variables
```

## ⚙️ Role Variables
```
module_blacklist: irdma
default_hugepagesz: 1G
hugepagesz: 1G
hugepages: 16
mc_name: "99-kernel-customizations-{{ node_role }}"
node_role: worker
```

## How to run

from the project root directory run the following command Bash
```
ansible-navigator run -m stdout playbooks/set_krn.yml # # If you have preconfigured image with all required modules to run ansible
```
or
```
ansible-playbook -i playbooks/set_krn.yml
```
