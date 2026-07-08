pipeline {
    agent any

    environment {
        IMAGE_REPO = "tassneem03/flask-notes-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_REPO:$IMAGE_TAG .'
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
                sh 'docker push $IMAGE_REPO:$IMAGE_TAG'
            }
        }

        stage('Update Helm Chart') {
            steps {
                sh '''
                    sed -i "s/tag:.*/tag: \\"${IMAGE_TAG}\\"/" flask-notes/values.yaml
                '''
            }
        }

        stage('Commit Helm Changes') {
            steps {
                sh '''
                    git config user.name "Jenkins"
                    git config user.email "jenkins@local"

                    git add flask-notes/values.yaml

                    git diff --cached --quiet || git commit -m "Update image tag to ${IMAGE_TAG}"
                '''
            }
        }

        stage('Push Helm Changes') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {
                    sh '''
                        git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/TassneemAmer/flask-notes-docker.git
                        git pull --rebase origin main
                        git push origin HEAD:main
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
            echo 'CI pipeline completed successfully. Argo CD will deploy the new version.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
