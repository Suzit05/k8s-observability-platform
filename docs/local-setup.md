

# Local Setup & Runbook — Kubernetes Observability Platform

---

No Need to Reinstall Everything After Restart?

After restarting your PC you only need to:

```
1. Start Docker
2. Verify cluster
3. Start Grafana port-forward
```

Everything else (Prometheus, Grafana, Loki, dashboards, alerts) **remains installed**.

---

# Project Directory

Go to the project folder first.

```bash
cd k8s-observability-platform
```

---

# Phase 3 & Phase 4 — Running the Cluster and Monitoring Stack

## Step 1 — Ensure Docker Is Running

Your **Kind cluster runs inside Docker**.

Check:

```bash
docker ps
```

If Docker is not running → start Docker Desktop.

---

## Step 2 — Verify Kubernetes Cluster

Check nodes:

```bash
kubectl get nodes
```

Expected:

```
observability-cluster-control-plane
observability-cluster-worker
observability-cluster-worker2
```

If nodes appear → cluster is running.

---

## Step 3 — Verify Monitoring Stack

Check monitoring namespace:

```bash
kubectl get pods -n monitoring
```

Expected pods:

```
monitoring-grafana
prometheus-monitoring-kube-prometheus
alertmanager-monitoring-kube-prometheus
kube-state-metrics
prometheus-node-exporter
```

If these are **Running**, monitoring stack is healthy.

---

## Step 4 — Start Grafana Access

Run:

```bash
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

⚠️ Keep this terminal **running**.

---

## Step 5 — Open Grafana

Open browser:

```
http://localhost:3000
```

Login:

```
Username: admin
Password: SYSHxr2vLmZVnZl2nlmqAejF8Qw9HykINrDShYpi
```

Now you can view **cluster metrics dashboards**.

---

# Phase 5 — Logging Stack Setup (One-Time Setup)

This installs centralized logging.

---

## Step 1 — Create Logging Folder

```bash
mkdir logging
```

Project structure:

```
k8s-observability-platform
│
├── kubernetes
├── helm
├── monitoring
└── logging
```

---

## Step 2 — Add Helm Repository

Install charts using **Helm**

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

---

## Step 3 — Install Logging Stack

```bash
helm install loki grafana/loki-stack -n monitoring
```

This installs:

```
Loki
Promtail
Grafana integration
```

---

## Step 4 — Verify Logging Components

Check pods:

```bash
kubectl get pods -n monitoring
```

Expected:

```
loki-0
loki-promtail-xxxxx
loki-promtail-yyyyy
```

Check DaemonSet:

```bash
kubectl get daemonset -n monitoring
```

Expected:

```
loki-promtail
```

Check Promtail pods:

```bash
kubectl get pods -n monitoring | grep promtail
```

---

## Step 5 — Add Loki Data Source in Grafana

Open Grafana.

Navigate:

```
Connections
→ Data Sources
→ Add Data Source
```

Select:

```
Loki
```

URL:

```
http://loki:3100
```

Click:

```
Save & Test
```

---

# Deploy Test Application

Deploy test nginx application:

```bash
kubectl apply -f kubernetes/nginx-deployment.yaml
kubectl apply -f kubernetes/nginx-service.yaml
```

Verify pods:

```bash
kubectl get pods
```

---

# Generate Logs for Testing

Use port-forward (recommended for Kind):

```bash
kubectl port-forward svc/nginx-test-service 8080:80
```

Then generate traffic:

```bash
while true; do curl localhost:8080; done
```

This generates logs inside the cluster.

---

# View Logs in Grafana

Open Grafana.

Go to:

```
Explore
```

Select data source:

```
Loki
```

Run query:

```
{namespace="default"}
```

You should now see **nginx logs appearing**.

Example:

```
GET / 200
GET / 200
GET / 200
```

---

# Observability Architecture

Metrics pipeline:

```
Prometheus → Grafana
```

Logs pipeline:

```
Pods → Promtail → Loki → Grafana
```

Full flow:

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
     Grafana
```

---

# After PC Restart

You only need to run:

```
1. Start Docker
2. cd k8s-observability-platform
3. kubectl get nodes
4. kubectl get pods -n monitoring
5. kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

Then open:

```
http://localhost:3000
```

Everything will work again.

---

# When You Must Reinstall Everything

Only if you run:

```bash
kind delete cluster
```

or remove Docker containers.

Then repeat:

```
Phase 3
Phase 4
Phase 5
```

---

# Useful Tips

Use **port-forward** to access any service:

```
kubectl port-forward svc/<service-name> <local-port>:<service-port> -n <namespace>
```

Example:

```
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
kubectl port-forward svc/nginx-test-service 8080:80
kubectl port-forward svc/loki 3100:3100 -n monitoring
```

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
│   ├── monitoring-notes.md
│   └── prometheus-alerts.yml
│
├── logging
│   └── loki-values.yaml
│
└── docs
    ├── architecture.md
    └── local-setup.md
```

---

✅ This runbook now covers:

* cluster restart
* monitoring verification
* logging verification
* test traffic
* viewing logs
* troubleshooting

----
