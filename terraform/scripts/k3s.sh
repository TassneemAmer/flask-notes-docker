#!/bin/bash
set -euxo pipefail

echo "Waiting for network..."

until curl -fsSL https://aws.amazon.com >/dev/null
do
    sleep 5
done

echo "Network ready."

# -------------------------------------------------
# Log everything
# -------------------------------------------------
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "========================================="
echo "Starting k3s Bootstrap"
echo "========================================="

# -------------------------------------------------
# Update OS
# -------------------------------------------------
dnf update -y

# -------------------------------------------------
# Install required packages
# -------------------------------------------------
dnf install -y \
    git \
    wget \
    unzip \
    tar \
    jq \
    docker \
    java-21-amazon-corretto \
    amazon-cloudwatch-agent
# -------------------------------------------------
# Enable Docker
# -------------------------------------------------
systemctl enable docker
systemctl start docker

# -------------------------------------------------
# Install AWS CLI v2
# -------------------------------------------------
cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o awscliv2.zip

unzip -o awscliv2.zip

./aws/install --update

rm -rf aws awscliv2.zip

# -------------------------------------------------
# Install kubectl
# -------------------------------------------------
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl

# -------------------------------------------------
# Install Helm
# -------------------------------------------------
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -------------------------------------------------
# Install k3s
# -------------------------------------------------
curl -sfL https://get.k3s.io | sh -

# -------------------------------------------------
# Enable k3s
# -------------------------------------------------
systemctl enable k3s

systemctl start k3s

mkdir -p /home/ec2-user/.kube

cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config

NODE_IP=$(hostname -I | awk '{print $1}')

sed -i "s/127.0.0.1/${NODE_IP}/" /home/ec2-user/.kube/config

chown -R ec2-user:ec2-user /home/ec2-user/.kube

chmod 600 /home/ec2-user/.kube/config

# -------------------------------------------------
# Docker permissions
# -------------------------------------------------
usermod -aG docker ec2-user

# -------------------------------------------------
# Verify installation
# -------------------------------------------------
echo "========== Versions =========="

docker --version

git --version

aws --version

kubectl version --client

helm version

k3s --version

echo "========== Nodes =========="

echo "Waiting for k3s API..."

until k3s kubectl get nodes >/dev/null 2>&1
do
    sleep 5
done

echo "========== Nodes =========="

k3s kubectl get nodes

# -------------------------------------------------
# Deploy Application
# -------------------------------------------------
echo "========================================="
echo "Deploying Flask Notes Application"
echo "========================================="

cd /home/ec2-user

if [ ! -d flask-notes-docker ]; then
    git clone https://github.com/TassneemAmer/flask-notes-docker.git
else
    cd flask-notes-docker
    git pull
    cd ..
fi

cd flask-notes-docker/flask-notes

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm upgrade --install flask-notes .

echo "Waiting for deployments..."

kubectl rollout status deployment/flask-deployment --timeout=300s

kubectl rollout status deployment/nginx-deployment --timeout=300s

kubectl rollout status deployment/mysql-deployment --timeout=300s

echo
echo "========== Pods =========="
kubectl get pods

echo
echo "========== Services =========="
kubectl get svc

echo
echo "========================================="
echo "Bootstrap & Deployment Complete"
echo "========================================="