# Kubernetes Observability Platform with Terraform

## Overview

This project demonstrates how to build a production-style Kubernetes platform with automated infrastructure provisioning, monitoring, and centralized logging.

The infrastructure is provisioned using Terraform, Kubernetes is deployed using kubeadm, and observability is implemented using Prometheus, Grafana, Loki, and Promtail.

## Tech Stack

Infrastructure as Code
- Terraform

Container Orchestration
- Kubernetes (kubeadm)

Monitoring
- Prometheus
- Grafana

Logging
- Loki
- Promtail

Networking
- NGINX Ingress Controller

## Architecture

Developer
   │
   ▼
Terraform Infrastructure
   │
   ▼
Kubernetes Cluster
   │
   ├── Workloads
   ├── Ingress Controller
   │
   ▼
Monitoring
   ├── Prometheus
   └── Grafana
   │
   ▼
Logging
   ├── Loki
   └── Promtail

## Project Structure

terraform/
Infrastructure provisioning

kubernetes/
Kubernetes manifests

monitoring/
Monitoring stack configuration

logging/
Centralized logging stack

scripts/
Cluster setup scripts

docs/
Architecture documentation