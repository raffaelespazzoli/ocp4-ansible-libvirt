
Prepare environment variables

```shell
sudo dnf install -y ansible python-libvirt python-lxml
export BECOME_PASSWORD=<your sudo password>
export PUBLIC_SSH_KEY_FILE=<your public ssh key>
export PULL_SECRET_FILE=<your pull secret>
```

create cluster

```shell
ansible-playbook -i ./inventory ./playbooks/deploy-ocp.yaml
```

remove cluster

```shell
ansible-playbook -i ./inventory ./playbooks/cleanup.yaml
```
