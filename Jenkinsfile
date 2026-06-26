pipeline {
    agent any

    stages {
        stage('Test SSH') {
            steps {
                sshagent(credentials: ['k3s-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@98.93.250.247 "hostname && kubectl get nodes"
                    '''
                }
            }
        }
    }
}