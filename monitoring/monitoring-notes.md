# Monitoring Stack

This project uses the following monitoring tools:

- Prometheus for metrics collection
- Grafana for visualization
- Loki for log aggregation
- Promtail for log collection

## Deploy Monitoring Stack

helm install kube-prometheus prometheus-community/kube-prometheus-stack -n monitoring

## Deploy Logging Stack

helm install loki grafana/loki-stack -n monitoring

## Apply Alert Rules

kubectl apply -f monitoring/prometheus-alerts.yml

## Grafana Dashboard

Import dashboard:

monitoring/grafana-dashboard.json