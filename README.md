# Kubernetes installation on bare-metal
Kubernetes installation on bare-metal, Ubuntu 20.04 is used for master and Ubuntu 18.04 used for worker nodes. You can use VM as a node. kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00

# Required steps for the master and each worker node

Disable the swap (Only once) and check it from /etc/fstab.
``` 
swapoff -a
```
## DOCKER
Google apt repository key added (Only once).
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

Install Docker. 
```
sudo apt-get update
sudo apt-get install -y docker.io
```

Configure managements of the container's cgroups.  
```
sudo mkdir /etc/docker
   
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Enable it to run the docker service when the system start.
```
sudo systemctl enable docker.service
systemctl restart docker
```
## KUBERNETES

Kubernetes apt repository added (Only once).
```
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
```

Install Kubernetes.  
```
sudo apt update && sudo apt install -y kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00
```

Enable it to run the kubelet service when the system start.
```
sudo systemctl enable kubelet.service
systemctl restart kubelet
```  

Check the status of Kubelet and Docker services. 
```
sudo systemctl status kubelet.service   
sudo systemctl status docker.service
```

# Required steps for the master

Download calico.yaml file and determine pod-network-cidr according to calico.yaml file.
```
wget https://docs.projectcalico.org/v3.14/manifests/calico.yaml
sudo kubeadm init --apiserver-advertise-address=10.40.30.100 --pod-network-cidr={CALICO_IP}/16  --ignore-preflight-errors=all
```

Create a user that has authority to reach API server.   
```
mkdir -p $HOME/.kube  
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config  
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```  

Create the pod network using downloaded calico.yaml.  
```
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f calico.yaml
```

To get and list worker node token.
```
kubeadm token create --print-join-command
kubeadm token list
```

Check kubernetes system pods, services and nodes.  
```
kubectl get pods --all-namespaces -o wide 
kubectl get svc --all-namespaces
kubectl get nodes -o wide 
sudo systemctl status kubelet.service
```

Regenerate a token for worker nodes.
```
kubeadm token create
```
# Required steps for each worker node 

Initializes a Kubernetes worker node and joins it to the cluster while using given token from master.  
```
sudo kubeadm join {IP}:6443 --token{TOKEN} --discovery-token-ca-cert-hash <ca_cert_hash>
kubeadm join --token 702ff6.bc7aacff7aacab17 174.138.15.158:6443 --discovery-token-ca-cert-hash sha256:68bc22d2c631800fd358a6d7e3998e598deb2980ee613b3c2f1da8978960c8ab 
```


# Remove Docker and Kubernetes

Uninstall Docker
```
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker.io
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo apt remove docker-*
```

Uninstall K8s
```
sudo kubeadm reset
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*
sudo rm -rf ~/.kube
```
