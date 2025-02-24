# cert_manager

The Cert Manager ansible role provides the official cert-manager from cert-manager.io.

This is currently required as the cert-manager-operator does not currently support disconnected installs. Once this ability is added (either to the operator or when OCP 4 support mirror repositories based on tags (OCP4.6 ~ Nov)) then we should use the operator from the operator catalog.

## Parameters

There are no parameters.

## Initial setup.

You should get the cert-manager.yaml file for the release you're interested in from https://github.com/jetstack/cert-manager/releases, save it to template/cert-manager.yml.j2, and replace the quay.io registry with the Odyssey repos:

```
$ sed -i 's/quay.io/docker.odyssey.apps.csintra.net/' templates/cert-manager.yml.j2
```
The you will have to add the following section to the end of cert-manager deployment:

```
{% if ocp4_cluster_config['datacenter'] == 'N18' and ocp4_cluster_config['network_zone'] in ["ciBasic", "ciPlus", "ciPlus_CH"] %}
          - name: https_proxy
            value: http://intranet-proxy.ch.hedani.net:8080
          - name: no_proxy
            value: 172.30.0.1
{% endif %}
```

This will ensure that proxy is used for N18 installations in ciBasic, ciPlus, and ciPlus_CH zones, so that the issuer is able to contact Venafi API.

## Usage

Here you can find an example playbook:

```yaml
---
- name: Example playbook to deploy cert-manager
  hosts: localhost
  roles:
  - role: cert_manager
```

## Reference

* https://cert-manager.io/docs/installation/openshift/
