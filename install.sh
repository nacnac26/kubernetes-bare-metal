sudo apt-get install -y docker.io &&
sudo systemctl enable docker.service &&
systemctl restart docker &&

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


sudo apt-get install -y kubelet kubeadm kubectl &&
sudo systemctl enable kubelet.service &&
echo done
