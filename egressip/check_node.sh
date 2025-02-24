#!/bin/bash

# Path to kubeconfig
export KUBECONFIG=/path/to/kubeconfig

# Email settings
TO_EMAIL="team@example.com"
SUBJECT="ALERT: Node NotReady in OpenShift Cluster"
EMAIL_BODY="/tmp/node_status_email.txt"

# SMS settings (using Linux 'mail' + an email-to-SMS gateway)
PHONE_NUMBER="1234567890"
SMS_GATEWAY="@txt.att.net"  # Change based on carrier
SMS_TO="${PHONE_NUMBER}${SMS_GATEWAY}"

# Get all nodes
ALL_NODES=$(oc get nodes -o jsonpath='{.items[*].metadata.name}')

# Track NotReady nodes
NOT_READY_NODES=()

for node in $ALL_NODES; do
    STATUS=$(oc get node "$node" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
    if [ "$STATUS" != "True" ]; then
        NOT_READY_NODES+=("$node")
    fi
done

# If any node is NotReady, send email and SMS
if [ ${#NOT_READY_NODES[@]} -gt 0 ]; then
    echo "The following nodes are NOT READY:" > $EMAIL_BODY
    for n in "${NOT_READY_NODES[@]}"; do
        echo "$n" >> $EMAIL_BODY
    done
    echo "" >> $EMAIL_BODY
    echo "Check cluster immediately: $(date)" >> $EMAIL_BODY

    # Send email
    mail -s "$SUBJECT" "$TO_EMAIL" < $EMAIL_BODY

    # Send SMS
    mail -s "Node Alert" "$SMS_TO" < $EMAIL_BODY
fi

