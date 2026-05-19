pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        AWS_REGION      = 'us-east-1'
        PROJECT_NAME    = 'techchallenge2'
        AWS_ACCOUNT_ID  = '496411573862'

        FRONTEND_REPO   = "${PROJECT_NAME}-frontend"
        BACKEND_REPO    = "${PROJECT_NAME}-backend"

        FRONTEND_SERVICE = "${PROJECT_NAME}-frontend-svc"
        BACKEND_SERVICE  = "${PROJECT_NAME}-backend-svc"
        ECS_CLUSTER      = "${PROJECT_NAME}-cluster"

        ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        FRONTEND_IMAGE  = "${ECR_REGISTRY}/${FRONTEND_REPO}"
        BACKEND_IMAGE   = "${ECR_REGISTRY}/${BACKEND_REPO}"

        IMAGE_TAG       = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                set -e
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Build Frontend Image') {
            steps {
                dir('frontend') {
                    sh '''
                        set -e
                        docker build -t $FRONTEND_IMAGE:latest -t $FRONTEND_IMAGE:$IMAGE_TAG .
                    '''
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                dir('backend') {
                    sh '''
                        set -e
                        docker build -t $BACKEND_IMAGE:latest -t $BACKEND_IMAGE:$IMAGE_TAG .
                    '''
                }
            }
        }

        stage('Push Images') {
            steps {
                sh '''
                    set -e
                    docker push $FRONTEND_IMAGE:latest
                    docker push $FRONTEND_IMAGE:$IMAGE_TAG
                    docker push $BACKEND_IMAGE:latest
                    docker push $BACKEND_IMAGE:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy Frontend') {
            steps {
                sh '''
                    set -e
                    aws ecs update-service \
                        --cluster $ECS_CLUSTER \
                        --service $FRONTEND_SERVICE \
                        --force-new-deployment \
                        --region $AWS_REGION
                '''
            }
        }

        stage('Deploy Backend') {
            steps {
                sh '''
                    set -e
                    aws ecs update-service \
                        --cluster $ECS_CLUSTER \
                        --service $BACKEND_SERVICE \
                        --force-new-deployment \
                        --region $AWS_REGION
                '''
            }
        }

        stage('Wait for Deployment') {
            steps {
                sh '''
                    set -e
                    aws ecs wait services-stable \
                        --cluster $ECS_CLUSTER \
                        --services $FRONTEND_SERVICE $BACKEND_SERVICE \
                        --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}