#!/bin/bash
set -euxo pipefail

# =========================================================
# Log everything
# =========================================================
exec > >(tee -a /var/log/user-data.log)
exec 2>&1

echo "========================================="
echo "Starting Jenkins Bootstrap"
echo "========================================="

# =========================================================
# Wait for Internet connectivity
# =========================================================
echo "Waiting for Internet connectivity..."

until curl -fsSL https://aws.amazon.com >/dev/null
do
    sleep 5
done

echo "Internet connectivity established."

# =========================================================
# Update package cache
# =========================================================
dnf makecache -y

# =========================================================
# Update system
# =========================================================
dnf update -y

# =========================================================
# Install required packages
# =========================================================
dnf install -y \
    git \
    wget \
    unzip \
    tar \
    jq \
    docker \
    java-21-amazon-corretto \
    amazon-cloudwatch-agent

# =========================================================
# Start Docker
# =========================================================
systemctl enable docker
systemctl start docker

# =========================================================
# Install Jenkins Repository
# =========================================================
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# =========================================================
# Install Jenkins
# =========================================================
dnf makecache -y

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# =========================================================
# Install AWS CLI v2
# =========================================================
cd /tmp

curl -L \
https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
-o awscliv2.zip

unzip -oq awscliv2.zip

./aws/install --update

rm -rf aws
rm -f awscliv2.zip

# =========================================================
# Install kubectl
# =========================================================
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO \
https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

install -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl

# =========================================================
# Install Helm
# =========================================================
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# =========================================================
# Docker permissions
# =========================================================
usermod -aG docker ec2-user

if id jenkins >/dev/null 2>&1; then
    usermod -aG docker jenkins
fi

# =========================================================
# Jenkins directories
# =========================================================
mkdir -p /var/lib/jenkins/.ssh
mkdir -p /var/lib/jenkins/.aws

chown -R jenkins:jenkins /var/lib/jenkins || true

# =========================================================
# Restart services
# =========================================================
systemctl restart docker
systemctl restart jenkins

# =========================================================
# Display versions
# =========================================================
echo
echo "========== Versions =========="

java -version

docker --version

docker compose version || true

git --version

aws --version

kubectl version --client

helm version

echo
echo "========== Service Status =========="

systemctl --no-pager --full status docker || true

systemctl --no-pager --full status jenkins || true

echo
echo "========================================="
echo "Jenkins Bootstrap Complete"
echo "========================================="