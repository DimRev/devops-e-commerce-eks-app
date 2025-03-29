import groovy.transform.Field

@Field def ENV = ''
@Field def APP_NAME = ''
@Field def ERROR = ''


pipeline {
    agent any
    stages {
        stage("Setup Environment") {
            steps {
                script {
                    echo "========EXEC: Setup Environment========"
                    try {
                        def userInput = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the environment', name: 'ENV')
                            ]
                        )
                        echo "User Input returned: ${userInput}"
                        if (userInput == null || userInput.trim().isEmpty()) {
                            error('Please provide the required details')
                        }
                        ENV = userInput
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME']
                        ]) {
                            def envExists = sh(script: "aws s3 ls s3://${S3_BACKEND_NAME}/envs/.env.${ENV}", returnStatus: true)
                            if (envExists != 0) {
                                error("File .env.${ENV} does not exist in bucket")
                            }

                            sh "aws s3 cp s3://${S3_BACKEND_NAME}/envs/.env.${ENV} .env"
                            def appNameValue = sh(script: "cat .env | grep BACKEND_APP_NAME | cut -d '=' -f 2", returnStdout: true).trim()
                            APP_NAME = appNameValue

                            ENV = ENV.toLowerCase().replace('_', '-')
                            APP_NAME = APP_NAME.toLowerCase().replace('_', '-')

                            def helmReleaseExists = sh(script: "helm list | grep ${ENV}-${APP_NAME}-chart", returnStatus: true)
                            if (helmReleaseExists != 0) {
                                error("Helm Chart ${ENV}-${APP_NAME}-chart does not exist")
                            }
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Setup Environment========"
                    echo "ENV: ${env.ENV}"
                }
                failure {
                    echo "========FAILURE: Setup Environment========"
                    echo "ERROR: ${env.ERROR}"
                }
            }
        }
        stage("Checkout code") {
            steps {
                script {
                    echo "========EXEC: Checkout code========"
                    try {
                        checkout scm
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                always {
                    sh "rm -f .env"
                }
                success {
                    echo "========SUCCESS: Checkout code========"
                }
                failure {
                    echo "========FAILURE: Checkout code========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Check and Destroy HELM Chart") {
            steps {
                script {
                    echo "========EXEC: Check and Destroy HELM Chart========"
                    try {
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME']
                        ]) {
                            sh "sudo chmod +x ./scripts/backend-helm-destroy.sh"
                            sh "./scripts/backend-helm-destroy.sh"
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                always {
                    sh "rm -f .env"
                }
                success {
                    echo "========SUCCESS: Check and Destroy HELM Chart========"
                }
                failure {
                    echo "========FAILURE: Check and Destroy HELM Chart========"
                    echo "ERROR: ${env.ERROR}"
                }
            }
        }
    }
    post {
        success {
            echo "========Pipeline executed successfully========"
        }
        failure {
            echo "========Pipeline execution failed========"
        }
    }
}
