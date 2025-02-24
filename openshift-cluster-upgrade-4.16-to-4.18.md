
# OpenShift Cluster Upgrade from 4.16.X to 4.18.X

## Table of Contents

1. [Preface](#preface)  
2. [Audience](#audience)  
3. [Prerequisites](#prerequisites)  
4. [How to Upgrade](#how-to-upgrade)  
5. [Known Issues](#known-issues)  
6. [Post-Upgrade Steps](#post-upgrade-steps)  

---

## Preface

This document provides a step-by-step procedure to upgrade an OpenShift cluster from version **4.16.X to 4.18.X**, following a stable path through intermediate version **4.17.35**. It includes all the necessary preparation steps, upgrade commands, and post-upgrade actions, along with known issues and mitigations.

---

## Audience

This document is intended for the following roles:

- **CaaS Engineers**
- **CaaS Operations Teams**

These teams are responsible for managing the lifecycle of OpenShift clusters including upgrades and infrastructure maintenance.

---

## Prerequisites

Before beginning the upgrade, ensure the following steps are completed:

### ✅ 1. Check Cluster Health

Ensure the cluster is in a healthy state before proceeding.

```sh
oc get co
oc get clusterversion
```

Verify all ClusterOperators show:

- **Available: True**
- **Progressing: False**
- **Degraded: False**

### ✅ 2. Mirror Images (if applicable)

If you are using a disconnected or restricted environment and images have not been mirrored yet, follow the official Red Hat documentation to mirror release images:

- [Image Mirroring for Disconnected Clusters](https://docs.openshift.com/container-platform/latest/updating/updating-restricted-network-cluster/mirroring-image-repository.html)

After mirroring, trigger your internal mirroring pipeline to ensure images are accessible.

---

## How to Upgrade

### 🔹 1. Check Current Cluster Version and Channel

```sh
oc get clusterversion
```

Review the current upgrade channel and version.

### 🔹 2. Patch Channel to 4.17

Begin by updating to the intermediate 4.17 release:

```sh
oc patch clusterversion version --type=merge -p '{"spec":{"channel":"stable-4.17"}}'
```

Wait until the update to **4.17.35** completes.

Then patch to **4.18**:

```sh
oc patch clusterversion version --type=merge -p '{"spec":{"channel":"stable-4.18"}}'
```

---

### 🔹 3. Create Release Image ConfigMap (If Missing)

Ensure the `release` ConfigMap exists in the `openshift-config-managed` namespace:

```sh
oc get configmap -n openshift-config-managed | grep release
```

If missing, create a ConfigMap pointing to your release image.

---

### 🔹 4. Check Desired Upgrade Image

Use the following command to list available updates:

```sh
oc adm upgrade
```

Note the full `--to-image` path for the desired release (e.g., 4.18.1).

---

### 🔹 5. Pause MCP for Worker and Infra Pools

Before applying the upgrade image, pause the MachineConfigPools:

```sh
oc patch mcp worker -p '{"spec":{"paused":true}}' --type=merge
oc patch mcp infra -p '{"spec":{"paused":true}}' --type=merge
```

---

### 🔹 6. Trigger the Upgrade

Apply the upgrade image explicitly:

```sh
oc adm upgrade --to-image=<release-image> --allow-explicit-upgrade=true
```

Example:

```sh
oc adm upgrade --to-image=quay.io/openshift-release-dev/ocp-release:4.18.1-x86_64 --allow-explicit-upgrade=true
```

---

### 🔹 7. Monitor Upgrade Progress

Monitor progress with:

```sh
watch oc get clusterversion
watch oc get co
```

Ensure all ClusterOperators become **Available** and not **Progressing** or **Degraded**.

---

## Known Issues

### ⚠️ Infrastructure/VMware (vSphere) Issues

- Some infrastructure upgrades may fail on VMware platforms due to known CSI driver or configuration issues.
- Refer to the official Red Hat **KCS (Knowledgebase Solution)** for guidance on the specific vSphere error.

> 🛡 **Mitigation**: Apply the recommended fix *only after taking a backup of the affected infrastructure custom resources (CRs)*.

---

## Post-Upgrade Steps

### ✅ Unpause MCP for Worker and Infra Pools

After confirming that the upgrade has completed and all operators are stable:

```sh
oc patch mcp worker -p '{"spec":{"paused":false}}' --type=merge
oc patch mcp infra -p '{"spec":{"paused":false}}' --type=merge
```

---

### ✅ Final Validation

Ensure everything is healthy:

```sh
oc get co
oc get clusterversion
```

You should see:

- `Cluster version is 4.18.X`
- `All cluster operators are available`

---

## ✅ Done!

You have successfully upgraded your OpenShift cluster from 4.16.X to 4.18.X.
