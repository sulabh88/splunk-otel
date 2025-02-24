#!/bin/bash

if ! command -v oc &> /dev/null; then
    echo "Error: 'oc' command not found. Please install OpenShift CLI and log in."
    exit 1
fi

if ! oc whoami &> /dev/null; then
    echo "Error: Not logged into OpenShift. Run 'oc login' first."
    exit 1
fi

echo "Scanning cluster for stuck pods..."

delete_stuck_pods() {
    echo "---------------------------------------"
    echo "Checking for pods in Terminating state..."
    TERMINATING_PODS=$(oc get pods --all-namespaces --field-selector=status.phase=Terminating -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}')
    
    if [ -n "$TERMINATING_PODS" ]; then
        echo "Found pods in Terminating state:"
        echo "$TERMINATING_PODS"
        echo "Force deleting these pods..."
        while IFS= read -r line; do
            NAMESPACE=$(echo "$line" | awk '{print $1}')
            POD=$(echo "$line" | awk '{print $2}')
            oc delete pod "$POD" -n "$NAMESPACE" --force --grace-period=0
        done <<< "$TERMINATING_PODS"
    else
        echo "No pods in Terminating state found."
    fi

    echo "---------------------------------------"
    echo "Checking for pods stuck in Pending state for over 5 minutes..."
    PENDING_PODS=$(oc get pods --all-namespaces --field-selector=status.phase=Pending -o json | jq -r '.items[] | select((now - (.metadata.creationTimestamp | fromdateiso8601)) > 300) | [.metadata.namespace, .metadata.name] | join(" ")')
    
    if [ -n "$PENDING_PODS" ]; then
        echo "Found pods in Pending state for over 5 minutes:"
        echo "$PENDING_PODS"
        echo "Force deleting these pods..."
        while IFS= read -r line; do
            NAMESPACE=$(echo "$line" | awk '{print $1}')
            POD=$(echo "$line" | awk '{print $2}')
            oc delete pod "$POD" -n "$NAMESPACE" --force --grace-period=0
        done <<< "$PENDING_PODS"
    else
        echo "No long-pending pods found."
    fi

    echo "---------------------------------------"
    echo "Checking for stuck Portworx pods..."
    PORTWORX_PODS=$(oc get pods --all-namespaces -o json | jq -r '.items[] | select(.metadata.name | contains("portworx")) | select(.status.phase=="Pending" or .status.phase=="Terminating" or (.status.conditions[]?.status=="False" and .status.conditions[]?.reason=="PodFailed")) | [.metadata.namespace, .metadata.name] | join(" ")')
    
    if [ -n "$PORTWORX_PODS" ]; then
        echo "Found stuck Portworx pods:"
        echo "$PORTWORX_PODS"
        echo "Force deleting these Portworx pods..."
        while IFS= read -r line; do
            NAMESPACE=$(echo "$line" | awk '{print $1}')
            POD=$(echo "$line" | awk '{print $2}')
            oc delete pod "$POD" -n "$NAMESPACE" --force --grace-period=0
        done <<< "$PORTWORX_PODS"
    else
        echo "No stuck Portworx pods found."
    fi
}

echo "WARNING: This script will forcefully delete stuck pods across ALL namespaces."
echo "This includes pods stuck due to PDBs, in Terminating state, waiting excessively, and Portworx pods."
read -p "Are you sure you want to proceed? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted by user."
    exit 0
fi

delete_stuck_pods

echo "---------------------------------------"
echo "Done! Check cluster status with 'oc get pods --all-namespaces'."
