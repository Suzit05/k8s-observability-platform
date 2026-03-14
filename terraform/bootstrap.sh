#!/bin/bash

set -e

echo "🚀 Starting Kubernetes Setup..."

# 1. Update and Prerequisites
sudo apt update -y 
sudo apt install -y apt-transport-https ca-certificates curl gpg

# 2. Disable Swap
echo "🛑 Disabling Swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# 3. Kernel Modules & Network Setup
echo "🌐 Configuring Network..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# 4. Containerd Installation & Fix
echo "📦 Installing Containerd..."
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# CRITICAL: Setting SystemdCgroup to true (K8s requirement)
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# 5. Kubernetes Repo & GPG Key (Fixed path & permissions)
echo "🔑 Adding Kubernetes Repo..."
sudo mkdir -p -m 755 /etc/apt/keyrings
# Key download with overwrite protection
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 6. Install K8s Packages
echo "🛠️ Installing Kubeadm, Kubelet, Kubectl..."
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 7. Final Verification
echo "---------------------------------------"
if command -v kubeadm &> /dev/null
then
    echo "✅ SUCCESS: $(kubeadm version -o short) is installed!"
else
    echo "❌ ERROR: kubeadm installation failed."
    exit 1
fi
echo "---------------------------------------"