// Import the annotation so our globals persist between stages
import groovy.transform.Field

@Field def ENV = ''
@Field def APP_NAME = ''
@Field def API_URL = ''
@Field def ERROR = ''

pipeline {
    agent any

    stages {
        stage("Get Deployment Info") {
            steps {
                script {
                    echo "========EXEC: Get Deployment Info========"
                    try {
                        def userInput = input(
                            message: 'Please provide deployment details:',
                            parameters: [
                                string(defaultValue: 'dev', description: 'Environment (dev, staging, prod)', name: 'ENV'),
                                string(defaultValue: 'e-commerce', description: 'Application name', name: 'APP_NAME'),
                                string(defaultValue: 'some-api-url', description: 'Backend API URL', name: 'API_URL')
                            ]
                        )

                        ENV = userInput.ENV
                        APP_NAME = userInput.APP_NAME
                        API_URL = userInput.API_URL

                        echo "Environment: ${ENV}"
                        echo "App Name: ${APP_NAME}"
                        echo "API URL: ${API_URL}"

                        if (ENV.trim().isEmpty() || APP_NAME.trim().isEmpty() || API_URL.trim().isEmpty()) {
                            error("All fields are required")
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Get Deployment Info========"
                }
                failure {
                    echo "========FAILURE: Get Deployment Info========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }

        stage("Checkout Code") {
            steps {
                script {
                    echo "========EXEC: Checkout Code========"
                    try {
                        checkout scm
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Checkout Code========"
                }
                failure {
                    echo "========FAILURE: Checkout Code========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }

        stage("Configure React App") {
            steps {
                script {
                    echo "========EXEC: Configure React App========"
                    try {
                        // Create .env file for React app with the provided API URL
                        sh """
                        cat > app/frontend-app/.env.production << EOL
VITE_API_URL=${API_URL}
VITE_APP_ENV=${ENV}
VITE_APP_NAME=${APP_NAME}
VITE_APP_VERSION=\$(date +%Y.%m.%d-%H%M)
EOL
                        """

                        sh "cat app/frontend-app/.env.production"
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Configure React App========"
                }
                failure {
                    echo "========FAILURE: Configure React App========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }

        stage("Build React App") {
            steps {
                script {
                    echo "========EXEC: Build React App========"
                    try {
                        dir('app/frontend-app') {
                            sh "pnpm i"
                            sh "pnpm run build"
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Build React App========"
                }
                failure {
                    echo "========FAILURE: Build React App========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }

        stage("Deploy to S3") {
            steps {
                script {
                    echo "========EXEC: Deploy to S3========"
                    try {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                            // Sync the build directory to the S3 bucket's html directory
                            sh "aws s3 sync app/frontend-app/dist/ s3://${ENV}-${APP_NAME}-app-bucket/html/ --delete"
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Deploy to S3========"
                }
                failure {
                    echo "========FAILURE: Deploy to S3========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
    }

    post {
        always {
            echo "========Pipeline Completed========"
        }
        success {
            echo "========Pipeline Executed Successfully========"
        }
        failure {
            echo "========Pipeline Execution Failed========"
            echo "ERROR: ${ERROR}"
        }
    }
}
