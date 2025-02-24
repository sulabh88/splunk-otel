# Ansible Role: EgressIP Management

## Role Purpose
This Ansible role automates the management of **EgressIP objects** in an OpenShift/Kubernetes cluster.

- **Create and apply EgressIP YAML files** for namespaces/projects in a cluster.
- Ensure that all configured EgressIPs are consistently applied across clusters.
- Support recovery after cluster restore or unexpected loss of EgressIP assignments.

## Prerequisites
1. The EgressIP YAML files **must exist** inside the `files/` directory for the role.
2. Each project should have a **dedicated subdirectory** under `files/`, named after the project.
3. Each EgressIP file must follow the naming convention:


### Example Directory Structure
files/
└── project1/
├── ns1-cluster1-egress.yaml
├── ns2-cluster1-egress.yaml
└── ns3-cluster2-egress.yaml


## How it Works

1. **First-time EgressIP assignment:**
   - The YAML file must be manually created and placed under the appropriate project folder.
   - Example: `files/project1/ns1-cluster1-egress.yaml`

2. **Subsequent runs:**
   - The role will automatically fetch **all EgressIP YAML files** for the target cluster across all projects.
   - Applies all files every time the role runs.
   - Checks for file existence before applying to avoid errors.

3. **Cluster recovery:**
   - If EgressIP assignments are lost due to cluster restore or other issues, simply **run the role again** for the cluster.
   - EgressIP objects will be re-created and assigned to the appropriate namespaces/projects automatically.

## Example EgressIP File
```yaml
apiVersion: k8s.ovn.org/v1
kind: EgressIP
metadata:
  name: ns1-cluster1-egress
spec:
  egressIPs:
    - 192.168.1.10
  namespaceSelector:
    matchLabels:
      kubernetes.io/metadata.name: ns1


+-----------------+        +-----------------+
|  files/project1 |        |  files/project2 |
|  ns1-cluster1   |        |  ns2-cluster1   |
|  ns2-cluster1   |        |  ns3-cluster2   |
+-----------------+        +-----------------+
         |                        |
         |                        |
         v                        v
   +-------------------------------+
   | Ansible Role: EgressIP Apply  |
   |   - Reads all project files   |
   |   - Checks if file exists     |
   |   - Applies EgressIP objects  |
   +-------------------------------+
                     |
                     v
        +------------------------+
        | Cluster EgressIP Status|
        |   - EgressIP assigned  |
        |     to namespace       |
        +------------------------+

