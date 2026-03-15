#!/bin/bash

echo "Installing Helm..."

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Adding Prometheus Helm repository..."

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

echo "Creating monitoring namespace..."

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "Installing Prometheus + Grafana using Helm values file..."

helm install monitoring prometheus-community/kube-prometheus-stack \
-f helm/prometheus-values.yaml \
-n monitoring

echo "Waiting for pods..."

sleep 30

kubectl get pods -n monitoring

echo "Getting Grafana password..."

kubectl --namespace monitoring get secrets monitoring-grafana \
-o jsonpath="{.data.admin-password}" | base64 --decode

echo ""

echo "Access Grafana with:"

echo "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"