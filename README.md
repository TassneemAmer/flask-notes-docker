# End-to-End DevOps CI/CD Pipeline for Flask Notes Application

A production-style DevOps project demonstrating the complete software delivery lifecycle from source code to automated deployment on Kubernetes.

The project automates application build, testing, containerization, image publishing, and deployment using Jenkins, Docker, Kubernetes (k3s), Helm, and AWS. It also includes infrastructure monitoring with Prometheus and Grafana.

---

# Architecture

```
                Git Push
                   │
                   ▼
              GitHub Repository
                   │
             GitHub Webhook
                   │
                   ▼
          Jenkins CI/CD Pipeline
                   │
        ┌──────────┴──────────┐
        │                     │
        ▼                     ▼
 Docker Image Build     Kubernetes Deployment
        │                     │
        ▼                     ▼
    Docker Hub         k3s Cluster (AWS EC2)
                             │
      ┌──────────────────────┼────────────────────────┐
      │                      │                        │
      ▼                      ▼                        ▼
 Flask Notes App         MySQL Database          NGINX
      │
      ▼
 Prometheus Metrics
      │
      ▼
 Grafana Dashboards
```

---

# Features

- Automated CI/CD pipeline using Jenkins
- GitHub webhook triggers deployments automatically
- Dockerized Flask application
- Image publishing to Docker Hub
- Kubernetes deployment using k3s
- Helm-managed Kubernetes releases
- Persistent MySQL storage
- NGINX reverse proxy
- Self-healing Kubernetes workloads
- Prometheus monitoring
- Grafana dashboards
- Environment-based configuration
- Non-root application container

---

# Tech Stack

## Cloud

- AWS EC2
- Elastic IP

## CI/CD

- Jenkins
- GitHub Webhooks

## Containers

- Docker
- Docker Hub

## Orchestration

- Kubernetes (k3s)
- Helm

## Monitoring

- Prometheus
- Grafana

## Backend

- Python
- Flask
- MySQL

## Operating System

- Amazon Linux
- Linux CLI

---

# Project Structure

```
.
├── app/
├── db/
├── flask-notes/          # Helm Chart
├── k8s/                  # Kubernetes manifests
├── Jenkinsfile
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example
└── README.md
```

---

# CI/CD Pipeline

Every push to the GitHub repository automatically triggers Jenkins.

Pipeline stages:

1. Checkout source code
2. Build Docker image
3. Login to Docker Hub
4. Push image
5. Connect to Kubernetes server via SSH
6. Restart Kubernetes deployment
7. Wait for successful rollout

---

# Kubernetes Deployment

The application runs inside a single-node k3s cluster hosted on AWS EC2.

Components include:

- Flask Deployment
- Flask Service
- MySQL Deployment
- MySQL Service
- NGINX Deployment
- NGINX Service
- Persistent Volume
- Persistent Volume Claim

Kubernetes automatically restarts failed containers and maintains the desired application state.

---

# Helm

The project includes a reusable Helm chart that packages the complete application.

Helm manages:

- Deployments
- Services
- Persistent Storage
- Configuration values

Deployment is simplified to a single Helm release.

---

# Monitoring

Monitoring is implemented using the kube-prometheus-stack Helm chart.

Installed components include:

- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- kube-state-metrics
- Prometheus Operator

Grafana dashboards provide real-time monitoring for:

- CPU Usage
- Memory Usage
- Network Traffic
- Pod Health
- Workload Metrics
- Cluster Metrics

---

# Infrastructure

AWS Resources:

- Jenkins EC2 Instance
- k3s Kubernetes EC2 Instance
- Elastic IP
- Security Groups

---

# Application Features

- Create notes
- View notes
- REST API
- MySQL persistent storage
- Health check endpoint

---

# Running Locally

## Docker Compose

```bash
docker compose up --build
```

Application:

```
http://localhost:8080
```

---

# Kubernetes Deployment

Apply manifests:

```bash
kubectl apply -f k8s/
```

or install using Helm:

```bash
helm install flask-notes ./flask-notes
```

---

# Monitoring

Install monitoring stack:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create namespace monitoring

helm install monitoring prometheus-community/kube-prometheus-stack \
--namespace monitoring
```

Expose Grafana:

```bash
kubectl patch svc monitoring-grafana \
-n monitoring \
-p '{"spec":{"type":"NodePort"}}'
```

Access Grafana:

```
http://<EC2_PUBLIC_IP>:<NODE_PORT>
```

Default username:

```
admin
```

Password:

```bash
kubectl get secret monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-password}" | base64 --decode
```

---

# Screenshots

## CI/CD Pipeline

*(Add Jenkins pipeline screenshots here)*

---

## Kubernetes

*(Add kubectl get pods and services screenshots here)*

---

## Grafana Dashboards

*(Add your monitoring dashboard screenshots here)*

---

## Application

*(Add screenshots of the running Notes application here)*

---

# Skills Demonstrated

- DevOps
- CI/CD
- Jenkins
- Docker
- Docker Hub
- Kubernetes
- Helm
- AWS
- Linux
- Git
- GitHub Webhooks
- Infrastructure Monitoring
- Prometheus
- Grafana
- MySQL
- Flask

---

# Future Improvements

- Terraform Infrastructure as Code
- Argo CD GitOps
- HTTPS with Ingress Controller
- Application Metrics
- Automated Testing
- Horizontal Pod Autoscaling

---

# Author

**Tassneem Amer**

Junior DevOps Engineer

LinkedIn: https://www.linkedin.com/in/tassneem-amer/

GitHub: https://github.com/TassneemAmer<img width="1912" height="866" alt="Screenshot 2026-07-06 174013" src="https://github.com/user-attachments/assets/c7df42b3-4329-4c75-b3fe-34429a57a280" />
<img width="1912" height="511" alt="Screenshot 2026-07-06 173925" src="https://github.com/user-attachments/assets/e4a67f19-96d1-417a-9479-672f4d6c792a" />
<img width="1918" height="822" alt="Screenshot 2026-07-06 173935" src="https://github.com/user-attachments/assets/89c0976d-f79e-4604-9658-3619b1b66909" />
<img width="1906" height="902" alt="Screenshot 2026-07-06 173955" src="https://github.com/user-attachments/assets/4d276c69-1ab0-478f-8063-bc7a3ae98834" />
