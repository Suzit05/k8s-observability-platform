#!/bin/bash

echo "Updating system..."
sudo apt update -y

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Adding Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

echo "Updating Helm repos..."
helm repo update

echo "Creating monitoring namespace..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "Installing kube-prometheus-stack (Prometheus + Grafana)..."
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring

echo "Waiting for pods to start..."
sleep 30

echo "Checking monitoring pods..."
kubectl get pods -n monitoring

echo "Getting Grafana admin password..."

kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode

echo ""
echo "-----------------------------------------"
echo "Grafana installed successfully!"
echo "Access Grafana using port-forward:"
echo ""
echo "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"
echo ""
echo "Then open:"
echo "http://localhost:3000"
echo ""
echo "Username: admin"
echo "Password: (shown above)"
echo "-----------------------------------------"