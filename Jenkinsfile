pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "maazmohemmed/save-the-forest"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'ae798623-fda7-4c12-9b30-89db69efe0e7') {
                        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    sh "trivy image ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh "minikube start"
                    // The image will be pulled from Docker Hub, so no need to build again.
                    // The minikube docker-env is also not needed since kubectl pulls the image directly.
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