#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "[TASK 3] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Install helm 3
echo "[TASK 5] Install helm 3"
curl -L "https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz" -o helm-v3.0.3-linux-amd64.tar.gz
gunzip helm-v3.0.3-linux-amd64.tar.gz
tar xf helm-v3.0.3-linux-amd64.tar
rm helm-v3.0.3-linux-amd64.tar
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64

# Install istio
echo "[TASK 6] Install istio binary"
curl -L https://istio.io/downloadIstio | sh -
sudo cp istio*/bin/istioctl /usr/local/bin/istioctl
