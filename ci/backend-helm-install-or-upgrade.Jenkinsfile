pipeline {
    agent any
    environment {
        ENV = ''
        APP_NAME = ''
        // ERROR
        ERROR = ''
    }
    stages {
        stage("Setup Environment") {
            steps {
                echo "========EXEC: Setup Environment========"
                try {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                        [string(credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME')]
                    ]) {
                        script {
                            def userInput = input(
                                message: 'Please provide the required details:',
                                parameters: [
                                    string(defaultValue: '', description: 'Enter the environment', name: 'ENV')
                                ]
                            )

                            if (userInput.ENV.isEmpty()) {
                                error('Please provide the required details')
                            }

                            env.ENV = userInput.ENV

                            def envExists = sh(script: "aws s3 ls s3://${S3_BACKEND_NAME}/envs/.env.${env.ENV}", returnStatus: true)
                            if (envExists != 0) {
                                error("File .env.${env.ENV} does not exist in bucket")
                            }
                        }
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
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
                echo "========EXEC: Checkout code========"
                try {
                    checkout scm
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                        [string(credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME')]
                    ]) {
                        sh "aws s3 cp s3://${S3_BACKEND_NAME}/envs/.env.${env.ENV} .env"
                        def appNameValue = sh(script: "cat .env | grep BACKEND_APP_NAME | cut -d '=' -f 2", returnStdout: true).trim()
                        env.APP_NAME = appNameValue
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
                }
            }
            post {
                success {
                    echo "========SUCCESS: Checkout code========"
                }
                failure {
                    echo "========FAILURE: Checkout code========"
                    echo "ERROR: ${env.ERROR}"
                }
            }
        }
        stage("Install or Upgrade Helm Chart") {
            steps {
                try {
                    script {
                        def helmReleaseExists = sh(script: "helm list | grep ${env.ENV}-${env.APP_NAME}-Chart", returnStatus: true)
                        if (helmReleaseExists != 0) {
                            sh "chmod +x ./scripts/backend-helm-install.sh"
                            sh "./scripts/backend-helm-install.sh"
                        } else {
                            sh "chmod +x ./scripts/backend-helm-upgrade.sh"
                            sh "./scripts/backend-helm-upgrade.sh"
                        }
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
                }
            }
            post {
                always {
                    sh "rm -f .env"
                }
                success {
                    echo "====SUCCESS: Install or Upgrade Helm Chart========"
                }
                failure {
                    echo "====FAILURE: Install or Upgrade Helm Chart========"
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
