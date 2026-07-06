#!/bin/bash
set -eux

echo "========== Deploying Application =========="

cd /home/ec2-user

if [ ! -d flask-notes-docker ]; then
    git clone https://github.com/TassneemAmer/flask-notes-docker.git
else
    cd flask-notes-docker
    git pull
    cd ..
fi

cd flask-notes-docker/flask-notes

helm upgrade --install flask-notes .

kubectl rollout status deployment/flask-deployment --timeout=300s
kubectl rollout status deployment/nginx-deployment --timeout=300s
kubectl rollout status deployment/mysql-deployment --timeout=300s

kubectl get pods
kubectl get svc

echo "========== Deployment Complete =========="