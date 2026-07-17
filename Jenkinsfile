pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'rehanrajpoot'
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
                sh """
                    sed -i "s|image: ${BACKEND_IMAGE}:.*|image: ${BACKEND_IMAGE}:${IMAGE_TAG}|g" k8s/05-backend-deployment-service.yaml
                    sed -i "s|image: ${FRONTEND_IMAGE}:.*|image: ${FRONTEND_IMAGE}:${IMAGE_TAG}|g" k8s/06-frontend-deployment-service.yaml
                """
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh """
                        git config user.email "jenkins@ci.local"
                        git config user.name "Jenkins CI"
                        git add k8s/05-backend-deployment-service.yaml k8s/06-frontend-deployment-service.yaml
                        git commit -m "Update image tags to build ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"
                        git push https://\${GIT_USER}:\${GIT_TOKEN}@github.com/RehanRajpoot1/taskmanager-devops.git HEAD:main
                    """
                }
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
