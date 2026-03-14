#!/bin/bash

echo "Initializing Kubernetes Control Plane..."

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

echo "Configuring kubectl..."

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Installing Calico Network..."

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "Waiting for cluster components..."

sleep 20

kubectl get nodes
kubectl get pods -n kube-system

echo "Generating worker join command..."

kubeadm token create --print-join-command > join-command.sh

echo "Join command saved in join-command.sh"

cat join-command.sh

echo "Master setup completed!"