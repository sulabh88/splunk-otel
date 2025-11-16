#!/bin/bash

# --- Config ---
CONTROL_NODE="control-abc.com"
NODE_USER="core"
SSH_KEY="/sshkey"

SWITCH_IP="10.10.10.10"
SWITCH_USER="CEUSER"
SWITCH_PASSWORD="password"

EMAIL="you@example.com"
THRESHOLD_MB=$((21 * 1024))   # 21 GiB in MB

SSHPASS_LOCAL="/usr/bin/sshpass"
SSHPASS_REMOTE="/tmp/sshpass"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')


# --- Step 1: Copy sshpass to control node ---
echo "Copying sshpass to control node..."
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i "$SSH_KEY" "$SSHPASS_LOCAL" "${NODE_USER}@${CONTROL_NODE}:${SSHPASS_REMOTE}" >/dev/null 2>&1

ssh -i "$SSH_KEY" \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    "${NODE_USER}@${CONTROL_NODE}" "chmod +x ${SSHPASS_REMOTE}"


# --- Step 2: SSH into control node → SSH into switch ---
echo "Checking switch memory..."

MEM_OUTPUT=$(ssh -i "$SSH_KEY" \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    "${NODE_USER}@${CONTROL_NODE}" "
        SSHPASS='$SWITCH_PASSWORD' ${SSHPASS_REMOTE} \
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        ${SWITCH_USER}@${SWITCH_IP} 'free -m'
    "
)

FREE_MEM=$(echo "$MEM_OUTPUT" | awk '/Mem:/ {print $7}')

echo "Free Memory on switch: ${FREE_MEM} MB"


# --- Step 3: Send alert if memory is low ---
if (( FREE_MEM < THRESHOLD_MB )); then
    SUBJECT=\"⚠️ Low Memory Alert on Switch ($SWITCH_IP)\"
    BODY=\"Switch: $SWITCH_IP
Free Memory: ${FREE_MEM} MB
Threshold: ${THRESHOLD_MB} MB
Time: $TIMESTAMP\"

    echo -e \"$BODY\" | mail -s \"$SUBJECT\" \"$EMAIL\"
    echo \"❌ ALERT SENT\"
else
    echo \"✔ Memory OK\"
fi

