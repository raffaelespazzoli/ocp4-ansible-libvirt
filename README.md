
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

access the cluster 

```shell
oc adm certificate approve
export KUBECONFIG=./install/auth/kubeconfig
```

```shell
oc new-project keepalived-operator
helm template ~/go/src/github/redhat-cop/keepalived-operator/charts/keepalived-operator ... | oc apply -f 
oc adm policy add-scc-to-user privileged -z default -n keepalived-operator
oc apply -f ./keepalived-group.yaml -n keepalived-operator
export ALLOWED_CIDR="192.168.131.128/26"
export AUTOASSIGNED_CIDR="192.168.131.192/26"
oc patch network cluster -p "$(envsubst < ./network-patch.yaml | yq -j .)" --type=merge
oc apply -f ./service.yaml
```

