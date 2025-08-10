pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "maazmohemmed/save-the-forest"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    sh "docker run --rm -v $(pwd):/app aquasec/trivy:0.18.3 --severity CRITICAL,HIGH --exit-code 1 ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh "minikube start"
                    sh "minikube docker-env"
                    sh "eval $(minikube docker-env)"
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                    sh "kubectl apply -f kubernetes/deployment.yaml"
                    sh "kubectl apply -f kubernetes/service.yaml"
                    sh "kubectl get deployments"
                    sh "kubectl get services"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh "minikube service save-the-forest-service --url"
                }
            }
        }
    }
}