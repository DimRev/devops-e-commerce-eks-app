pipeline {
    agent any
    environment {
        // ENVS
        ENV = ''
        APP_NAME = ''
        BACKEND_IMAGE_NAME = ''
        BACKEND_IMAGE_REPO = ''
        BACKEND_IMAGE_VERSION = ''
        // ERROR
        ERROR = ''
    }
    stages {
        stage("User Input") {
            steps {
                echo "========EXEC: User Input========"
                try {
                    script {
                        def userInput = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the environment', name: 'ENV'),
                                string(defaultValue: '', description: 'Enter the app name', name: 'APP_NAME')
                            ]
                        )

                        if (userInput.ENV.isEmpty() || userInput.APP_NAME.isEmpty()) {
                            error('Please provide the required details')
                        }

                        env.ENV = userInput.ENV
                        env.APP_NAME = userInput.APP_NAME
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
                }
            }
            post {
                success {
                    echo "========SUCCESS: User Input========"
                    echo "ENV: ${env.ENV}"
                    echo "APP_NAME: ${env.APP_NAME}"
                }
                failure {
                    echo "========FAILURE: User Input========"
                    echo "ERROR: ${env.ERROR}"
                }
            }
        }
        stage("Check bucket") {
            steps {
				echo "========EXEC: Check bucket========"
                try {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                        [string(credentialsId: 's3_backend_name', variable: 's3_backend_name')]
                    ]) {
                        def fileStatus = sh(script: "aws s3 ls s3://${s3_backend_name_NAME}/envs/.env.${env.ENV}", returnStatus: true)
                        if (fileStatus == 0) {
                            echo "File .env.${env.ENV} exists in bucket."
                            def userChoice = input(
                                message: "File .env.${env.ENV} already exists. Do you want to delete it?",
                                parameters: [
                                    choice(
                                        name: 'DELETE_CHOICE',
                                        choices: "Yes\nNo",
                                        description: "Select 'Yes' to delete the file, 'No' to abort the build."
                                    )
                                ]
                            )
                            if (userChoice == "Yes") {
                                sh "aws s3 rm s3://${s3_backend_name_NAME}/envs/.env.${env.ENV}"
                                echo "File .env.${env.ENV} deleted from bucket."
                            } else {
                                error("User chose to abort and not delete the file")
                            }
                        } else {
                            echo "File .env.${env.ENV} does not exist. Proceeding with the pipeline."
                        }
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
                }
            }
            post {
                success {
                    echo "========SUCCESS: Check bucket========"
                }
                failure {
                    echo "========FAILURE: Check bucket========"
                    echo "ERROR: ${env.ERROR}"
                }
            }
        }
        stage("Generate .env file and upload") {
            steps {
				echo "========EXEC: Generate .env file and upload========"
                try {
                    script {
                        def userInput = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the backend image name', name: 'BACKEND_IMAGE_NAME'),
                                string(defaultValue: '', description: 'Enter the backend image repository', name: 'BACKEND_IMAGE_REPO'),
                                string(defaultValue: '', description: 'Enter the backend image version', name: 'BACKEND_IMAGE_VERSION'),
                                string(defaultValue: '', description: 'Enter the backend kinesis stream name', name: 'BACKEND_KINESIS_STREAM_NAME'),
                                string(defaultValue: '', description: 'Enter the backend aws region', name: 'BACKEND_AWS_REGION')
                            ]
                        )

                        if (
                            userInput.BACKEND_IMAGE_NAME.isEmpty() ||
                            userInput.BACKEND_IMAGE_REPO.isEmpty() ||
                            userInput.BACKEND_IMAGE_VERSION.isEmpty()
                        ) {
                            error('Please provide the required details')
                        }
                        env.BACKEND_IMAGE_NAME = userInput.BACKEND_IMAGE_NAME
                        env.BACKEND_IMAGE_REPO = userInput.BACKEND_IMAGE_REPO
                        env.BACKEND_IMAGE_VERSION = userInput.BACKEND_IMAGE_VERSION

                        sh "touch .env.${env.ENV}"
                        sh "echo BACKEND_IMAGE_NAME=${env.BACKEND_IMAGE_NAME} >> .env.${env.ENV}"
                        sh "echo BACKEND_IMAGE_REPO=${env.BACKEND_IMAGE_REPO} >> .env.${env.ENV}"
                        sh "echo BACKEND_IMAGE_VERSION=${env.BACKEND_IMAGE_VERSION} >> .env.${env.ENV}"
                        sh "echo BACKEND_ENV=${env.ENV} >> .env.${env.ENV}"
                        sh "echo BACKEND_APP_NAME=${env.APP_NAME} >> .env.${env.ENV}"
                        sh "echo BACKEND_KINESIS_STREAM_NAME=${env.BACKEND_KINESIS_STREAM_NAME} >> .env.${env.ENV}"
                        sh "echo BACKEND_AWS_REGION=${env.BACKEND_AWS_REGION} >> .env.${env.ENV}"

                        echo "File .env.${env.ENV} created"

                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [string(credentialsId: 's3_backend_name', variable: 's3_backend_name')]
                        ]) {
                            sh "aws s3 cp .env.${env.ENV} s3://${s3_backend_name_NAME}/envs/.env.${env.ENV}"
                            def fileStatus = sh(script: "aws s3 ls s3://${s3_backend_name_NAME}/envs/.env.${env.ENV}", returnStatus: true)
                            if (fileStatus == 0) {
                                echo "File .env.${env.ENV} uploaded to bucket"
                            } else {
                                error("File .env.${env.ENV} not uploaded to bucket")
                            }
                        }
                    }
                } catch (Exception e) {
                    env.ERROR = e.getMessage()
                    throw e
                }
            }
            post {
                always {
                    sh "rm -f .env.${env.ENV}"
                }
                success {
                    echo "========SUCCESS: Generate .env file and upload========"
                }
                failure {
                    echo "========FAILURE: Generate .env file and upload========"
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
