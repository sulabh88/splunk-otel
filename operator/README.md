# operator

This role installs and removes operators for OCP4.

If the operator supports AllNameSpaces then we use the openshift-operators namespace, if AllNameSpaces is not supported, then we will attempt to use the suggested namespace if there is one. If not, then a new namespace named after the operator name is used.

Note, there is no configuration of the operator done.

You can view the available operators using:

`oc get -n openshift_marketplace PackageManifests`

## Parameters

| Parameter           | Comment                  |
| ------------------- | ------------------------ |
| operator_state      | `present` or `absent`    |
| operator_name       | The name of the operator |

## Usage

Assuming you want to install the cert-manager-operator operator:

```yaml
---
- hosts: localhost
  name: Install and then remove the cert-manager-operator operator
  tasks:
  - name: Install operator
    include_role:
      name: operator
    vars:
      operator_state: present
      operator_name: cert-manager-operator
      K8S_AUTH_KUBECONFIG: /tmp/ocp4/auth/kubeconfig
      K8S_AUTH_SSL_CA_CERT: /tmp/ocp4/ca.crt
      K8S_AUTH_VERIFY_SSL: yes
    environment:
      K8S_AUTH_KUBECONFIG: /tmp/ocp4/auth/kubeconfig

  - name: Delete operator
    include_role:
      name: operator
    vars:
      operator_state: absent
      operator_name: cert-manager-operator
      K8S_AUTH_KUBECONFIG: /tmp/ocp4/auth/kubeconfig
      K8S_AUTH_SSL_CA_CERT: /tmp/ocp4/ca.crt
      K8S_AUTH_VERIFY_SSL: yes
    environment:
      K8S_AUTH_KUBECONFIG: /tmp/ocp4/auth/kubeconfig
```