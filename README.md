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

Put the following in an `.env` file:

```shell
export BECOME_PASSWORD=<your sudo password>
export PUBLIC_SSH_KEY_FILE=<your public ssh key>
export PULL_SECRET_FILE=<your pull secret>
```
The pull secret file from https://cloud.redhat.com/openshift/install follows the same format as a docker config file, so you can put your pull secrets in that file.

Then run the following to set your environment variables before running the playbook:

```sh
$ source .env
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

https://github.com/aerdei/ocp4-upi-virt-fcos 



to create a new release
oc adm -a /home/vrutkovs/src/github.com/vrutkovs/my-ocp-40/pull_secret_upload.json release new --from-release quay.io/vrutkovs/okd-release:4.4 --to-image quay.io/vrutkovs/okd-release:4.4-crio-fix \
machine-os-content=quay.io/vrutkovs/machine-os-content@sha256:24b820709d928c94b5278beeae3f39709c8cdb3f9cf5fba3dee20a3586a87eec

https://developers.redhat.com/blog/2019/10/29/verifying-signatures-of-red-hat-container-images/

https://github.com/containers/image/blob/master/docs/containers-policy.json.5.md
https://github.com/containers/image/blob/master/docs/containers-registries.conf.5.md