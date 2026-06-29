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
                    echo "Finding k3s server..."
                    
                    IP=$(aws ec2 describe-instances \
                        --region us-east-1 \
                        --filters \
                            "Name=tag:Name,Values=k3s-server" \
                            "Name=instance-state-name,Values=running" \
                        --query "Reservations[*].Instances[*].PublicIpAddress" \
                        --output text)

                    if [ -z "$IP" ] || [ "$IP" = "None" ]; then
                        echo "ERROR: No running k3s-server instance found."
                        exit 1
                    fi

                    echo "Deploying to $IP"
                    
                    ssh -o StrictHostKeyChecking=no ec2-user@$IP "
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
        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
