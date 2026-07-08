# 🚀 End-to-End DevOps CI/CD Pipeline for Flask Notes Application

A production-style DevOps project demonstrating the complete software delivery lifecycle, from infrastructure provisioning to automated deployment on Kubernetes.

The project automates infrastructure provisioning, application containerization, image publishing, and deployment using **Terraform, Jenkins, Docker, Kubernetes (k3s), Helm, Argo CD, and AWS**. It also includes infrastructure and cluster monitoring with **Prometheus** and **Grafana**.

![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazonaws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-k3s-326CE5?logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?logo=helm&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI-D24939?logo=jenkins&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?logo=argo&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-Dashboard-F46800?logo=grafana&logoColor=white)
---

# 🌐 Application

The Flask Notes application is deployed on a Kubernetes (k3s) cluster running on AWS EC2. Every code change pushed to GitHub is automatically built, containerized, and deployed through the CI/CD pipeline.
<img width="1786" height="907" alt="Screenshot 2026-07-08 132359" src="https://github.com/user-attachments/assets/0320edb6-3feb-41ee-8027-edeacdc57990" />

---

# 🏗 Architecture

```text
                     Terraform
                         │
                         ▼
                AWS Infrastructure
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
      Jenkins Server         Kubernetes (k3s)
                                     │
Developer                            │
    │                                │
    ▼                                ▼
 GitHub ── Webhook ──► Jenkins ──► Docker Build
                              │
                              ▼
                         Docker Hub
                              │
                              ▼
                    Kubernetes Deployment
                              │
               ┌──────────────┼──────────────┐
               │              │              │
               ▼              ▼              ▼
            Flask App      MySQL         NGINX
                              │
                              ▼
                        Prometheus
                              │
                              ▼
                           Grafana
```

---

# 🛠 Tech Stack

<img width="1536" height="1024" alt="ChatGPT Image Jul 8, 2026, 02_47_52 PM" src="https://github.com/user-attachments/assets/df5aaaf2-4a84-4206-9823-05948885a475" />

---

# 📁 Project Structure

```text
.
├── terraform/
│   ├── provider.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── data.tf
│   ├── security_groups.tf
│   ├── instances.tf
│   ├── elastic_ip.tf
│   └── outputs.tf
│
├── k8s/
│   ├── flask/
│   ├── mysql/
│   ├── nginx/
│   ├── pv.yaml
│   └── pvc.yaml
│
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│
├── Dockerfile
├── Jenkinsfile
├── app.py
└── README.md
```

---

# 🏗 Infrastructure (Terraform)

```text
Terraform
     │
     ▼
 AWS EC2
 ├── Jenkins Server
 └── Kubernetes (k3s)
```

Terraform provisions the AWS infrastructure, including EC2 instances, networking, security groups, and an Elastic IP. Managing infrastructure as code ensures deployments are reproducible, version-controlled, and easy to maintain.

---

# 🐳 Docker

```text
Application Source
        │
        ▼
   Docker Build
        │
        ▼
  Docker Image
        │
        ▼
   Docker Hub
```
<img width="1877" height="908" alt="image" src="https://github.com/user-attachments/assets/466676f7-a196-417f-9c2a-82c03796ada3" />

The Flask application is containerized using Docker to ensure a consistent runtime environment across development and production. Jenkins automatically builds and pushes updated images to Docker Hub whenever changes are committed.

---

# 🚀 CI/CD Pipeline (Jenkins)

```text
Developer
    │
    ▼
 Git Push
    │
    ▼
 GitHub
    │
(Webhook)
    │
    ▼
 Jenkins
    │
 ├── Checkout Source
 ├── Build Docker Image
 ├── Push to Docker Hub
 └── Deploy to Kubernetes
```
<img width="1863" height="896" alt="image" src="https://github.com/user-attachments/assets/cde9921e-6425-4e27-94a4-2d824447e8d7" />

Jenkins automates the entire deployment process, eliminating manual build and deployment steps while ensuring every release follows the same repeatable workflow.

---

# ☸️ Kubernetes Deployment

```text
Kubernetes Cluster
│
├── Flask Deployment
├── MySQL Deployment
├── NGINX Deployment
│
├── Services
├── Persistent Volume
└── Persistent Volume Claim
```
<img width="1575" height="450" alt="image" src="https://github.com/user-attachments/assets/4980a0ca-c450-48da-a98a-08b7d2b4fa5f" />

The application runs on a k3s Kubernetes cluster using Deployments, Services, Persistent Volumes, and Persistent Volume Claims. Kubernetes provides rolling updates, self-healing, service discovery, and persistent storage, making the application resilient and highly manageable.

---

# 📋 Helm

```text
Helm Chart
     │
     ▼
Templates + Values
     │
     ▼
Kubernetes Resources
```
<img width="1578" height="75" alt="image" src="https://github.com/user-attachments/assets/3a348871-8381-478d-91bf-e27f59352c5f" />
<img width="747" height="157" alt="image" src="https://github.com/user-attachments/assets/4cb083e1-68d1-498f-9b50-0eb4b259b4e5" />

Helm packages the Kubernetes manifests into reusable charts, simplifying deployment, configuration management, upgrades, and future maintenance.

---

# 🔄 GitOps (Argo CD)

```text
Git Repository
      │
      ▼
   Argo CD
      │
      ▼
 Kubernetes Cluster
```
<img width="1912" height="718" alt="image" src="https://github.com/user-attachments/assets/726436f6-5b17-4f0f-9f46-ec480f134521" />

Argo CD continuously monitors the Git repository and automatically synchronizes the Kubernetes cluster whenever changes are detected, ensuring the running environment always matches the desired state stored in Git.

---

# 📊 Monitoring

```text
Kubernetes
     │
     ▼
 Prometheus
     │
     ▼
  Grafana
     │
     ▼
 Dashboards & Metrics
```
<img width="1880" height="792" alt="image" src="https://github.com/user-attachments/assets/efced25e-c960-4c4a-a552-911887bfa50c" />
<img width="1871" height="585" alt="image" src="https://github.com/user-attachments/assets/97d290f6-88fc-4515-9fce-efe2d6ba013b" />

Prometheus collects metrics from the Kubernetes cluster, while Grafana visualizes those metrics through interactive dashboards, providing real-time insights into cluster health, resource utilization, and application performance.

---

# ✨ Features

* ✅ Infrastructure as Code with Terraform
* ✅ Automated CI/CD using Jenkins
* ✅ Dockerized Flask application
* ✅ Docker Hub image publishing
* ✅ Kubernetes (k3s) orchestration
* ✅ Helm-managed deployments
* ✅ GitOps with Argo CD
* ✅ Persistent MySQL storage
* ✅ NGINX reverse proxy
* ✅ Monitoring with Prometheus & Grafana
* ✅ Rolling updates and self-healing workloads

---

# 🔮 Future Improvements

* Migrate to Amazon EKS
* Implement Horizontal Pod Autoscaler (HPA)
* Configure HTTPS using Let's Encrypt
* Integrate automated unit and integration testing
* Implement container vulnerability scanning
* Configure automated database backups
* Expand Grafana dashboards and alerting

---
## Repository Statistics

- Infrastructure as Code using Terraform
- Complete CI/CD Pipeline
- GitOps Workflow
- Kubernetes Deployment
- Cloud Deployment on AWS
- Real-Time Monitoring with Prometheus & Grafana

# 👩‍💻 Author

**Tassneem Amer**

Junior DevOps Engineer

* GitHub: https://github.com/TassneemAmer
* LinkedIn: https://www.linkedin.com/in/tassneem-amer/
