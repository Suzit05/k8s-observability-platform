# Architecture

This project builds a Kubernetes platform with observability and logging.

Infrastructure Layer
Terraform provisions the required infrastructure including virtual machines and networking.

Cluster Layer
Kubernetes cluster is created using kubeadm with a control plane and worker nodes.

Application Layer
Sample workloads are deployed to generate traffic, logs, and metrics.

Observability Layer
Prometheus collects metrics from nodes and pods.
Grafana visualizes the metrics using dashboards.

Logging Layer
Promtail collects logs from Kubernetes pods.
Loki stores the logs.
Grafana provides log visualization.