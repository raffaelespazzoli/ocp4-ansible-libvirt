# OCP4 libvirt

This is an installation method for OCP 4.x designed to install OCP 4.x on personal laptop. The main difference from crc is that with this installation method you get a multinode cluster (your laptop needs to have the necessary resources to support multiple nodes).

A major difference from other bare metal approaches is that this approach does not use a helper node. The OCP requirements normally satisfied by the helper node are satisfied as follows:

1. DNS entries: libvirt DNS (which in turn is based on dnsmasq)
2. DHCP: libvirt network
3. ignition injection: libvirt qemu extension to inject ignition file (requires RHCOS qemu image, currently available [here](https://releases-rhcos-art.cloud.privileged.psi.redhat.com/) only via the RedHat VPN)
4. master load balancer: DNS based load balancer
5. router and other load balancers: keepalived operator

## Installation instructions

### Prepare environment variables

```shell
export BECOME_PASSWORD=<your sudo password>
export PUBLIC_SSH_KEY_FILE=<your public ssh key>
export PULL_SECRET_FILE=<your pull secret>
```

### Install ansible requirements

```shell
sudo dnf install -y ansible python-libvirt python-lxml python3-passlib
```

### Edit your inventory file

you can find an example [here](./inventory)

### Create cluster

```shell
ansible-playbook -v -i ./inventory ./playbooks/deploy-ocp.yaml
```

### Approve certificates

at a certain point during the installation the process will stop to allow you to approve certificates.
you should wait for two certificates for each of the nodes you created.
The needed commands are the following:

```shell
export KUBECONFIG=./install/auth/kubeconfig
oc get csr -o name | xargs oc adm certificate approve
```

### Access the cluster

```shell
export KUBECONFIG=./install/auth/kubeconfig
```

also you console should be available at:

`https://console-openshift-console.apps.<cluster-name>.<cluster-domain>`

### Remove cluster

```shell
ansible-playbook -v -i ./inventory ./playbooks/cleanup.yaml
```
