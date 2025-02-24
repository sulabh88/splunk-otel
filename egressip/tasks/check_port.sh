#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp6"   # Change this to the port you want to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- Get all switches with name and port state ---
switches=$(oc get switch -n "$NAMESPACE" -o name)

failed_ports=""

# Iterate over each switch
while IFS= read -r switch; do
    [[ -z "$switch" ]] && continue

    name=$(basename "$switch")

    # Extract port state for the desired port
    port_state=$(oc get "$switch" -n "$NAMESPACE" -o jsonpath="{.status.networkPortStatus[?(@.portNumber=='$PORT_NUMBER')].portState}")

    # If the port state is not UP, mark as failed
    if [[ "$port_state" != "UP" ]]; then
        if [[ -z "$failed_ports" ]]; then
            failed_ports="$name: $PORT_NUMBER -> $port_state"
        else
            failed_ports+=$'\n'"$name: $PORT_NUMBER -> $port_state"
        fi
    fi
done <<< "$switches"

# --- Send email only if there are failures ---
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi
************new***************
#!/bin/bash

# --- Configuration ---
NAMESPACE="ibm-fusion-ns"
CLUSTER_NAME="cluster"
EMAIL="you@example.com"
PORT_NUMBER="swp31"   # port to monitor
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Switch prefixes to monitor
PREFIXES=("hspeed1" "hspeed2")

failed_ports=""

# Get all switches in namespace
all_switches=$(oc get switch -n "$NAMESPACE" -o name | xargs -n1 basename)

# Iterate over switches and filter by prefix
for switch in $all_switches; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ "$switch" == "$prefix"* ]]; then
            # Extract port state for the desired port
            port_state=$(oc get switch "$switch" -n "$NAMESPACE" -o json | \
                         jq -r --arg port "$PORT_NUMBER" '.status.networkPortStatus[] | select(.portNumber==$port) | .portState')

            if [[ -z "$port_state" ]]; then
                echo "ℹ️ $switch does not have port $PORT_NUMBER (skipped)"
                continue
            fi

            if [[ "$port_state" != "UP" ]]; then
                if [[ -z "$failed_ports" ]]; then
                    failed_ports="$switch: $PORT_NUMBER -> $port_state"
                else
                    failed_ports+=$'\n'"$switch: $PORT_NUMBER -> $port_state"
                fi
            fi
        fi
    done
done

# Send email only if any failures
if [[ -n "$failed_ports" ]]; then
    SUBJECT="Port Failure Alert - $CLUSTER_NAME - $TIMESTAMP"
    BODY="The following switches have issues with port $PORT_NUMBER:\n\n$failed_ports"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$BODY"
else
    echo "✅ All $PORT_NUMBER ports are UP on monitored switches in $CLUSTER_NAME at $TIMESTAMP"
fi

