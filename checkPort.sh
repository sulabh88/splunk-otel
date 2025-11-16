#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
CONTROL_NODE="control-01"
SSHPASS_LOCAL="/usr/bin/sshpass"
SSHPASS_REMOTE="/tmp/sshpass"
SWITCH_USER="admin"
SWITCH_PASSWORD="yourSwitchPassword"   # plaintext or pull from vault
MEM_THRESHOLD_MB=1024                   # 1GB
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

# Ports to monitor
PORTS=("swp31" "swp32")

failed_ports=""

# --- Step 1: Verify cluster login ---
if ! oc whoami &>/dev/null; then
    SUBJECT="Cluster Login Failed - $CLUSTER_NAME - $TIMESTAMP"
    BODY="❌ Unable to connect to OpenShift cluster [$CLUSTER_NAME]. oc login may have expired or failed."
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
    exit 1
fi

# --- Step 2: Get all switches in namespace ---
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename 2>/dev/null)

# --- Step 3: Check ports ---
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            for port in "${PORTS[@]}"; do
                port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                             jq -r --arg port "$port" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

                if [[ -z "$port_state" ]]; then
                    echo "ℹ️ $switch does not have port $port (skipped)"
                    continue
                fi

                if [[ "$port_state" != "UP" ]]; then
                    if [[ -z "$failed_ports" ]]; then
                        failed_ports="$switch: $port -> $port_state"
                    else
                        failed_ports+=$'\n'"$switch: $port -> $port_state"
                    fi
                fi
            done
        fi
    done
done

# Send email if port failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with monitored ports:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All monitored ports are UP on switches in $CLUSTER_NAME at $TIMESTAMP"
fi

# --- Step 4: Copy sshpass to control-01 if not present ---
ssh "$CONTROL_NODE" "test -f $SSHPASS_REMOTE || sudo cp $SSHPASS_LOCAL $SSHPASS_REMOTE && sudo chmod +x $SSHPASS_REMOTE"

# --- Step 5: Check memory on switches ---
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            SWITCH_IP=$(oc get switch "$switch" -n "$NAMESPACE" -o jsonpath='{.spec.switchIpAddress}')
            if [[ -z "$SWITCH_IP" ]]; then
                echo "ℹ️ $switch does not have a switchIpAddress (skipped)"
                continue
            fi

            free_mem=$(ssh "$CONTROL_NODE" "$SSHPASS_REMOTE -p $SWITCH_PASSWORD ssh -o StrictHostKeyChecking=no $SWITCH_USER@$SWITCH_IP free -m | awk '/Mem:/ {print \$4}'")
            
            if [[ -z "$free_mem" ]]; then
                echo "⚠️ Could not get memory info for $switch ($SWITCH_IP)"
                continue
            fi

            if (( free_mem < MEM_THRESHOLD_MB )); then
                SUBJECT="Memory Alert - $CLUSTER_NAME - $switch - $TIMESTAMP"
                BODY="❌ $switch ($SWITCH_IP) has low free memory: ${free_mem}MB (<1GB)"
                echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
                echo "$BODY"
            else
                echo "✅ $switch free memory: ${free_mem}MB"
            fi
        fi
    done
done

