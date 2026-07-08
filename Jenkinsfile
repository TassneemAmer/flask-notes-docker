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

        stage('Skip Jenkins Commit') {
            steps {
                script {
                    def author = sh(
                        script: "git log -1 --pretty=%an",
                        returnStdout: true
                    ).trim()

                    echo "Latest commit author: ${author}"

                    if (author == "Jenkins") {
                        currentBuild.result = 'NOT_BUILT'
                        echo "Build triggered by Jenkins commit. Skipping pipeline."
                        return
                    }
                }
            }
        }

        stage('Build Docker Image') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                    docker build -t $IMAGE_REPO:$IMAGE_TAG .
                '''
            }
        }

        stage('Login to Docker Hub') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                    docker push $IMAGE_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Update Helm Chart') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                    sed -i "s/tag:.*/tag: \\"${IMAGE_TAG}\\"/" flask-notes/values.yaml
                '''
            }
        }

        stage('Commit Helm Changes') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                    git config user.name "Jenkins"
                    git config user.email "jenkins@local"

                    git add flask-notes/values.yaml

                    if ! git diff --cached --quiet; then
                        git commit -m "Update image tag to ${IMAGE_TAG}"
                    else
                        echo "No changes to commit."
                    fi
                '''
            }
        }

        stage('Push Helm Changes') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
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

        success {
            echo "Docker image ${IMAGE_TAG} built successfully."
            echo "Helm chart updated successfully."
            echo "Changes pushed to GitHub."
            echo "Argo CD will synchronize automatically."
        }

        unsuccessful {
            script {
                if (currentBuild.result == 'NOT_BUILT') {
                    echo "Pipeline skipped because it was triggered by a Jenkins-generated commit."
                } else {
                    echo "Pipeline failed."
                }
            }
        }

        always {
            sh 'docker logout || true'
        }
    }
}
