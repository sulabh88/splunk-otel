#!/bin/bash
# Collect CRI-O core dumps and sosreport from all compute nodes
# Keeps only the latest files (rotates hourly)

COMPUTE_NODES=("compute-0.example.com" "compute-1.example.com")
SSH_USER="core"
LOCAL_DIR="/home/sulabh/crio_dumps"
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir -p "$LOCAL_DIR"

# Proxy configuration
HTTPS_PROXY="http://your.proxy:port"
NO_PROXY="localhost,127.0.0.1,.example.com"

for NODE in "${COMPUTE_NODES[@]}"; do
  echo "[INFO] Collecting CRI-O core dump from $NODE"

  # --- Cleanup local old files ---
  echo "[INFO] Cleaning up old local files for $NODE"
  rm -f "$LOCAL_DIR/${NODE}-crio-core-"* || true
  rm -f "$LOCAL_DIR/${NODE}-sosreport-"* || true

  ssh -o StrictHostKeyChecking=no $SSH_USER@$NODE "bash -s" <<ENDSSH
set -euo pipefail

# Export proxy
export https_proxy=$HTTPS_PROXY
export no_proxy=$NO_PROXY

echo "[INFO] Cleaning up old files on node $NODE"
/bin/rm -f /tmp/crio.* /tmp/sosreport-* || true

echo "[INFO] Checking CRI-O PID on $NODE"
CRIO_PID=\$(pidof crio)
if [[ -z "\$CRIO_PID" ]]; then
  echo "[ERROR] CRI-O process not found"
  exit 1
fi

echo "[INFO] Pulling support-tools container"
podman login -u <RHN_USERNAME> -p <RHN_PASSWORD> registry.redhat.io
podman pull registry.redhat.io/rhel8/support-tools

echo "[INFO] Running support-tools with host namespaces"
CID=\$(podman run -d --rm --privileged --pid=host --net=host -v /:/host \
    registry.redhat.io/rhel8/support-tools sleep infinity)

echo "[INFO] Installing gcore tools inside container"
podman exec \$CID yum install -y gdb procps-ng -y >/dev/null

echo "[INFO] Generating CRI-O core dump"
podman exec \$CID gcore -o /host/tmp/crio \$CRIO_PID

echo "[INFO] Running sosreport"
podman exec \$CID sosreport --batch --tmp-dir /host/tmp || true

echo "[INFO] Stopping container"
podman stop \$CID || true
ENDSSH

  echo "[INFO] Copying fresh files from $NODE to local machine"
  scp -o StrictHostKeyChecking=no $SSH_USER@$NODE:/tmp/crio.* "$LOCAL_DIR/${NODE}-crio-core-${TIMESTAMP}"
  scp -o StrictHostKeyChecking=no $SSH_USER@$NODE:/tmp/sosreport-* "$LOCAL_DIR/${NODE}-sosreport-${TIMESTAMP}" || true

  echo "[INFO] Finished collecting from $NODE"
done

