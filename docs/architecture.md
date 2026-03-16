# Kubernetes Observability Platform Architecture

This project implements a full observability stack for Kubernetes using Prometheus, Grafana, Loki, and Promtail.

---

## System Architecture
                    +---------------------+
                    |      Developer      |
                    +----------+----------+
                               |
                               |
                        GitHub Repository
                               |
                               ▼
                       Kubernetes Cluster
                     (Kind / Local Cluster)
                               |
      -----------------------------------------------------
      |                        |                         |
      ▼                        ▼                         ▼
 Application Pods        Prometheus                Promtail
   (Nginx Test)       (Metrics Collection)     (Log Collection)
      |                        |                         |
      ▼                        ▼                         ▼
  Container Logs          Metrics Data               Loki
                                                      |
                                                      ▼
                                                   Grafana
                                             (Visualization Layer)