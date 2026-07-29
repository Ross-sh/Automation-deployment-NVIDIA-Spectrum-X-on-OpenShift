#!/bin/bash
if lsmod | grep -q mlx5_fwctl; then
  echo "fwctl already loaded"; exit 0
fi
CID=$(crictl ps --name mofed-container --state running -q 2>/dev/null | head -1)
if [ -z "$CID" ]; then
  echo "MOFED container not found"; exit 1
fi
echo "Found MOFED container: $CID"
KERN=$(uname -r)
MOD=/lib/modules/${KERN}/extra/mlnx-ofa_kernel/drivers/fwctl
crictl exec "$CID" insmod ${MOD}/fwctl.ko
crictl exec "$CID" insmod ${MOD}/mlx5/mlx5_fwctl.ko
lsmod | grep -q mlx5_fwctl && echo "fwctl modules loaded successfully" || { echo "Failed to load fwctl"; exit 1; }

