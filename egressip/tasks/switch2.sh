#!/bin/bash

# Configuration
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get all switches with name and status
switches=$(oc get switch -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,STATUS:.status.status --no-headers)

failed_switches=""

# Iterate over each switch line
while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue

    # Extract name and status
    name=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | cut -d' ' -f2- | xargs)  # trims spaces

    # Check if status is not "login successful"
    if [[ "$status" != "login successful" ]]; then
        if [[ -z "$failed_switches" ]]; then
            failed_switches="$name: $status"
        else
            failed_switches+=$'\n'"$name: $status"
        fi
    fi
done <<< "$switches"

# Send email only if there are failures
if [[ -n "$failed_switches" ]]; then
    SUBJECT="Switch Login Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches did not login successfully:\n\n$failed_switches"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All switches in $CLUSTER_NAME are successful at $TIMESTAMP"
fi

