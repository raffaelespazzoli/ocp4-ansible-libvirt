
Prepare environment variables

qcows releases can be found here: https://releases-rhcos-art.cloud.privileged.psi.redhat.com/ this is a vpn-only link so at least for the first download you need the VPN.


```shell
sudo dnf install -y ansible python-libvirt python-lxml python3-passlib
export BECOME_PASSWORD=<your sudo password>
export PUBLIC_SSH_KEY_FILE=<your public ssh key>
export PULL_SECRET_FILE=<your pull secret>
```

create mirror:

```shell
ansible-playbook -v -i ./inventory ./playbooks/deploy-mirror.yaml
```

create cluster

```shell
ansible-playbook -v -i ./inventory ./playbooks/deploy-ocp.yaml
```

remove cluster

```shell
ansible-playbook -v -i ./inventory ./playbooks/cleanup.yaml
```
