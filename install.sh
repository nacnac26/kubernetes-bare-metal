sudo apt-get update
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


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo apt install -y kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00 &&
sudo systemctl enable kubelet.service &&
echo done
