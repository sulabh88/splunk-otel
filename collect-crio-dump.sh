#!/bin/bash
# Collect CRI-O core dumps and sosreport from all compute nodes

COMPUTE_NODES=("compute-0.example.com" "compute-1.example.com")
SSH_USER="core"
LOCAL_DIR="/home/sulabh/crio_dumps"
mkdir -p "$LOCAL_DIR"

for NODE in "${COMPUTE_NODES[@]}"; do
  echo "[INFO] Collecting CRI-O core dump from $NODE"
  TIMESTAMP=$(date +%F_%H-%M-%S)

  ssh $SSH_USER@$NODE "bash -s" <<'ENDSSH'
set -e
echo "[INFO] Checking CRI-O version"
rpm -qa cri-o

echo "[INFO] Running support-tools container"
podman login registry.redhat.io
podman pull registry.redhat.io/rhel8/support-tools

CONTAINER_ID=$(podman container runlabel RUN registry.redhat.io/rhel8/support-tools)
echo "[INFO] Container ID: $CONTAINER_ID"

echo "[INFO] Installing gcore tools inside container"
podman exec $CONTAINER_ID yum install -y gdb procps-ng

echo "[INFO] Generating CRI-O core dump"
podman exec $CONTAINER_ID gcore -o /crio $(pidof crio)

echo "[INFO] Copy core dump to host /tmp"
podman exec $CONTAINER_ID cp /crio.* /host/tmp/

echo "[INFO] Collecting sosreport"
podman exec $CONTAINER_ID sosreport || podman exec $CONTAINER_ID sosreport -n crio
ENDSSH

  echo "[INFO] Copying files from $NODE to local machine"
  scp $SSH_USER@$NODE:/tmp/crio.* "$LOCAL_DIR/$NODE-crio-core-$TIMESTAMP"
  scp $SSH_USER@$NODE:/tmp/sosreport-* "$LOCAL_DIR/$NODE-sosreport-$TIMESTAMP"

  echo "[INFO] Finished collecting from $NODE"
done

