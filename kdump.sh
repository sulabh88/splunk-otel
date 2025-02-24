#!/bin/bash

# Description: Enable kdump on all compute/worker nodes with crashkernel=1024M

# Label to identify compute nodes (adjust if different in your cluster)
NODE_LABEL="node-role.kubernetes.io/worker"

# Get all compute nodes
nodes=$(oc get nodes -l $NODE_LABEL -o name)

for node in $nodes; do
    echo "======================================="
    echo "Processing node: $node"

    # 1. Append crashkernel parameter using rpm-ostree
    echo "Appending crashkernel=1024M..."
    oc debug $node -- chroot /host bash -c "
        rpm-ostree kargs --append='crashkernel=1024M'
    "

    # 2. Reboot node
    echo "Rebooting node: $node..."
    oc debug $node -- chroot /host bash -c "
        systemctl reboot
    "

    # Wait until node is Ready
    echo "Waiting for node $node to be Ready..."
    until oc get $node -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' | grep -q True; do
        echo -n "."
        sleep 10
    done
    echo ""
    echo "Node $node is Ready."

    # 3. Enable kdump service and check status
    echo "Enabling kdump..."
    oc debug $node -- chroot /host bash -c "
        systemctl enable --now kdump
        kdumpctl status
    "

    echo "Finished processing node: $node"
    echo "======================================="
done

echo "✅ Kdump enable process completed on all compute nodes."

