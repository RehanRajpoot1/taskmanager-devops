pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'your-dockerhub-username'   // <-- change this
        BACKEND_IMAGE  = "${DOCKERHUB_USER}/taskmanager-backend"
        FRONTEND_IMAGE = "${DOCKERHUB_USER}/taskmanager-frontend"
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Jenkins credential ID
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                dir('backend') {
                    sh "docker build -t ${BACKEND_IMAGE}:${IMAGE_TAG} -t ${BACKEND_IMAGE}:latest ."
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                dir('frontend') {
                    sh "docker build -t ${FRONTEND_IMAGE}:${IMAGE_TAG} -t ${FRONTEND_IMAGE}:latest ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                sh "docker push ${BACKEND_IMAGE}:${IMAGE_TAG}"
                sh "docker push ${BACKEND_IMAGE}:latest"
                sh "docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}"
                sh "docker push ${FRONTEND_IMAGE}:latest"
            }
        }

        stage('Update K8s Manifests (GitOps)') {
            steps {
                echo "Next phase: update image tag in manifests repo so ArgoCD can sync it."
                // This stage will be filled in Phase 6 (ArgoCD/GitOps setup)
            }
        }
    }

    post {
        success {
            echo "Build ${IMAGE_TAG} pushed successfully to DockerHub."
        }
        failure {
            echo "Build failed. Check logs above."
        }
        always {
            sh 'docker logout'
        }
    }
}
