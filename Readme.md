# Kubernetes Observability Platform

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Loki](https://img.shields.io/badge/Loki-000000?style=for-the-badge&logo=grafana&logoColor=white)

-----------------

# Kubernetes Observability Platform

A **production-style Kubernetes observability stack** demonstrating monitoring, logging, dashboards, and alerting for containerized applications.

This project showcases how to build a **complete observability pipeline** using modern cloud-native tools and deploy it in **two environments**:

* **Cloud Infrastructure (AWS EC2)**
* **Local Development (Kind Cluster)**

The goal is to simulate a **real DevOps monitoring environment** similar to what production teams use.

---

# Observability Architecture

Observability consists of collecting and analyzing **metrics, logs, and system events** to understand system health and troubleshoot issues. 

This project implements two core pipelines.

## Metrics Pipeline

```
Kubernetes Cluster
        │
        ▼
Node Exporter + Kube State Metrics
        │
        ▼
Prometheus
        │
        ▼
Grafana Dashboards
```

## Logging Pipeline

```
Application Pods
        │
        ▼
Promtail
        │
        ▼
Loki
        │
        ▼
Grafana Log Explorer
```

---

# Tech Stack

| Tool         | Purpose                       |
| ------------ | ----------------------------- |
| Kubernetes   | Container orchestration       |
| Amazon EC2   | Cloud infrastructure          |
| Kind         | Local Kubernetes cluster      |
| Prometheus   | Metrics collection            |
| Grafana      | Dashboards & visualization    |
| Grafana Loki | Centralized log storage       |
| Promtail     | Kubernetes log shipping       |
| Helm         | Kubernetes package deployment |

---

# Repository Structure

```
k8s-observability-platform
│
├── kubernetes
│   ├── nginx-deployment.yaml
│   └── nginx-service.yaml
│
├── monitoring
│   ├── grafana-dashboard.json
│   ├── prometheus-alerts.yml
│   └── monitoring-notes.md
│
├── logging
│   └── loki-values.yaml
│
├── docs
│   ├── architecture.md
│   └── local-setup.md
│
└── README.md
```

---

# Deployment Environments

## Cloud Deployment (AWS)

The cluster was first deployed on **AWS infrastructure** using:

* Amazon EC2
* Multi-node Kubernetes cluster

Architecture example:

```
AWS EC2 Instances
│
├── Control Plane
│
└── Worker Nodes
      │
      ▼
Kubernetes Cluster
      │
      ▼
Prometheus + Grafana
      │
      ▼
Loki Logging Stack
```

This setup demonstrates how observability stacks run in **real cloud environments**.

---

## Local Development Cluster

For development and testing, the project runs locally using:

* Kind

Example cluster:

```
observability-cluster-control-plane
observability-cluster-worker
observability-cluster-worker2
```

This allows testing the **full monitoring + logging stack locally without cloud cost**.

---

# Features

## Kubernetes Monitoring

Metrics collected include:

* Node CPU usage
* Memory consumption
* Pod resource metrics
* Kubernetes state metrics

Tools used:

* Prometheus
* Grafana

---

## Centralized Logging

Logs from Kubernetes pods are automatically collected.

Flow:

```
Pods → Promtail → Loki → Grafana
```

Tools used:

* Grafana Loki
* Promtail

---

## Dashboards

Grafana dashboards display:

* Cluster health
* Node metrics
* Pod metrics
* Resource usage
* Application logs

---

## Alerting

Alert rules configured using Prometheus.

Example alerts:

* High CPU usage
* Pod restart loops
* Node resource pressure

---

# Running the Project Locally

## 1. Create Local Cluster

```
kind create cluster --name observability-cluster
```

Verify:

```
kubectl get nodes
```

---

## 2. Install Monitoring Stack

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

---

## 3. Install Logging Stack

```
helm install loki grafana/loki-stack -n monitoring
```

---

## 4. Deploy Sample Application

```
kubectl apply -f kubernetes/nginx-deployment.yaml
kubectl apply -f kubernetes/nginx-service.yaml
```

---

# Access Grafana

Start port-forward:

```
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

Open:

```
http://localhost:3000
```

---

# Viewing Logs

In Grafana:

```
Explore → Loki
```

Query:

```
{namespace="default"}
```

This shows logs from Kubernetes pods.

---

# Generating Test Traffic

```
while true; do curl localhost:8080; done
```

This produces logs visible in Grafana.

---

# Observability Components

| Component    | Role               |
| ------------ | ------------------ |
| Prometheus   | Metrics collection |
| Grafana      | Dashboards         |
| Loki         | Log storage        |
| Promtail     | Log collector      |
| AlertManager | Alerting           |

---

# Key Learnings

This project demonstrates:

* Kubernetes cluster monitoring
* Observability architecture design
* Metrics collection with Prometheus
* Centralized logging with Loki
* Dashboard creation with Grafana
* Alerting with Prometheus rules
* Helm-based Kubernetes deployments
* Running Kubernetes on AWS infrastructure
* Local development using Kind

---

# Future Improvements

Potential enhancements:

* CI/CD pipeline using GitHub Actions
* Infrastructure provisioning with Terraform
* Slack/Email alert notifications
* Persistent log storage
* Kubernetes autoscaling

---

# Author

**Sujeet Kumar**

DevOps & Cloud Enthusiast

LinkedIn
[www.linkedin.com/in/sujeet05kp](http://www.linkedin.com/in/sujeet05kp)

---
