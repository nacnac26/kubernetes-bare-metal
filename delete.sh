sudo apt-get purge docker-ce docker-ce-cli containerd.io docker.io 
sudo rm -rf /var/lib/docker 
sudo rm -rf /var/lib/containerd 
sudo apt remove docker-* 


sudo kubeadm reset 
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* 
sudo rm -rf ~/.kube 
sudo rm -r /etc/docker 
echo done
