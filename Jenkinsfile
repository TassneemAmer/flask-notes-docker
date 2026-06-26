pipeline {
    agent any

    environment {
        IMAGE_NAME = "tassneem03/flask-notes-app:v1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy to k3s') {
            steps {
                sshagent(['k3s-ssh']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@98.93.250.247 "
                        kubectl rollout restart deployment/flask-deployment &&
                        kubectl rollout status deployment/flask-deployment
                    "
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}