sudo kubeadm init --apiserver-advertise-address=10.40.30.100 --pod-network-cidr={CALICO_IP}/16  --ignore-preflight-errors=all &&

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# wget https://docs.projectcalico.org/v3.14/manifests/calico.yaml
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f calico.yaml
echo done