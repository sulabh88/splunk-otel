#!/bin/bash
# Collect CRI-O core dumps and sosreport from all compute nodes
# Keeps only the latest files (rotates hourly by cleanup)

COMPUTE_NODES=("compute-0.example.com" "compute-1.example.com")
SSH_USER="core"
SSH_KEY="/path/to/private/key"   # <-- set your ssh private key path
LOCAL_DIR="/home/sulabh/crio_dumps"
TIMESTAMP=$(date +%F_%H-%M-%S)

# --- cleanup local files ---
rm -rf "$LOCAL_DIR"
mkdir -p "$LOCAL_DIR"

# Proxy config (if required)
HTTPS_PROXY="http://your.proxy:port"
NO_PROXY="localhost,127.0.0.1,.example.com"

for NODE in "${COMPUTE_NODES[@]}"; do
  echo "[INFO] Collecting CRI-O core dump from $NODE"

  ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no $SSH_USER@$NODE "bash -s" <<'ENDSSH'
set -euo pipefail

# Export proxy
export https_proxy=$HTTPS_PROXY
export no_proxy=$NO_PROXY

# cleanup node files
rm -f /tmp/crio.* /tmp/sosreport-* || true

CRIO_PID=\$(pidof crio || true)
if [[ -z "\$CRIO_PID" ]]; then
  echo "[ERROR] CRI-O process not found"
  exit 1
fi

# run support-tools container
CID=\$(podman run -d --rm --privileged --pid=host --net=host -v /:/host \
    registry.redhat.io/rhel8/support-tools sleep infinity)

# install gcore tools
podman exec \$CID yum install -y gdb procps-ng >/dev/null

# dump crio core
podman exec \$CID gcore -o /host/tmp/crio \$CRIO_PID

# collect sosreport
podman exec \$CID sosreport --batch --tmp-dir /host/tmp || true

# stop container
podman stop \$CID || true
ENDSSH

  # copy to local
  scp -i "$SSH_KEY" -o StrictHostKeyChecking=no $SSH_USER@$NODE:/tmp/crio.* \
    "$LOCAL_DIR/${NODE}-crio-core-${TIMESTAMP}" || true
  scp -i "$SSH_KEY" -o StrictHostKeyChecking=no $SSH_USER@$NODE:/tmp/sosreport-* \
    "$LOCAL_DIR/${NODE}-sosreport-${TIMESTAMP}" || true

  echo "[INFO] Finished collecting from $NODE"
done

