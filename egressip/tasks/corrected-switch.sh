#!/bin/bash

NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="my-cluster"
EMAIL="you@example.com"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get all switches with name and status
switches=$(oc get switch -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,STATUS:.status.status --no-headers)

failed_switches=""

while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue

    name=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | cut -d' ' -f2- | xargs)  # trim spaces

    # Only append if status is not exactly "login successful"
    if [[ "$status" != "login successful" ]]; then
        if [[ -z "$failed_switches" ]]; then
            failed_switches="$name: $status"
        else
            failed_switches+=$'\n'"$name: $status"
        fi
    fi

done <<< "$switches"

# Send email only if there are real failures
if [[ -n "$failed_switches" ]]; then
    SUBJECT="Switch Login Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches did not login successfully:\n\n$failed_switches"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All switches in $CLUSTER_NAME are successful at $TIMESTAMP"
fi
**********************
#!/bin/bash

EMAIL="you@example.com"
NAMESPACE="ibm-fusion-ns"

# Function: login to a cluster
login_cluster() {
    local cluster_name=$1
    local kubeconfig=$2

    echo "🔑 Switching context to cluster: $cluster_name"
    export KUBECONFIG="$kubeconfig"
}

# Function: check switches in the current cluster
check_switch_status() {
    local cluster_name=$1
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    switches=$(oc get switch -n "$NAMESPACE" \
        -o custom-columns=NAME:.metadata.name,STATUS:.status.status --no-headers)

    failed_switches=""
    while read -r line; do
        [[ -z "$line" ]] && continue
        name=$(echo "$line" | awk '{print $1}')
        status=$(echo "$line" | cut -d' ' -f2- | xargs)
        if [[ "$status" != "login successful" ]]; then
            failed_switches+=$'\n'"$name: $status"
        fi
    done <<< "$switches"

    if [[ -n "$failed_switches" ]]; then
        subject="❌ Switch Login Failure Alert - $cluster_name - $timestamp"
        body=$'The following switches did not login successfully:\n\n'"$failed_switches"
        echo -e "$body" | mail -s "$subject" "$EMAIL"
        echo "$body"
    else
        echo "✅ All switches in $cluster_name are successful at $timestamp"
    fi
}

### MAIN SCRIPT ###
clusters=(
  "cluster1 /home/user/.kube/cluster1.kubeconfig"
  "cluster2 /home/user/.kube/cluster2.kubeconfig"
)

for entry in "${clusters[@]}"; do
    cluster_name=$(echo "$entry" | awk '{print $1}')
    kubeconfig=$(echo "$entry" | awk '{print $2}')

    login_cluster "$cluster_name" "$kubeconfig"
    check_switch_status "$cluster_name"
done

