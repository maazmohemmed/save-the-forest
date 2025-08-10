pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "save-the-forest"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Use `docker.withRegistry` for a secure and clean way to manage Docker operations.
                    docker.withRegistry('https://registry.hub.docker.com', 'ae798623-fda7-4c12-9b30-89db69efe0e7') {
                        // Build and tag the image
                        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                        // Push the image to your Docker Hub repository
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    // Escape the '$' to prevent Groovy from interpreting it.
                    sh "docker run --rm -v \$(pwd):/app aquasec/trivy:0.18.3 --severity CRITICAL,HIGH --exit-code 1 ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh "minikube start"
                    // Use 'withEnv' to correctly set environment variables from 'minikube docker-env'.
                    // This is a more robust way to handle environment variables in Jenkins.
                    def minikubeEnv = sh(returnStdout: true, script: 'minikube docker-env').trim()
                    withEnv(["${minikubeEnv}"]) {
                        // The image is already built and pushed, so we need to rebuild it using the minikube docker daemon
                        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                        sh "kubectl apply -f kubernetes/deployment.yaml"
                        sh "kubectl apply -f kubernetes/service.yaml"
                        sh "kubectl get deployments"
                        sh "kubectl get services"
                    }
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