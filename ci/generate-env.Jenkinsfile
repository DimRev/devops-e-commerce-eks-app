// Import the annotation so our globals persist between stages.
import groovy.transform.Field

@Field def ENV = ''
@Field def APP_NAME = ''
@Field def BACKEND_IMAGE_NAME = ''
@Field def BACKEND_IMAGE_REPO = ''
@Field def BACKEND_IMAGE_VERSION = ''
@Field def BACKEND_KINESIS_STREAM_NAME = ''
@Field def BACKEND_AWS_REGION = ''
@Field def EKS_CLUSTER_NAME = ''
@Field def ERROR = ''

pipeline {
    agent any

    stages {
        stage("User Input") {
            steps {
                script {
                    echo "========EXEC: User Input========"
                    try {
                        def userInput = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the environment', name: 'ENV'),
                                string(defaultValue: '', description: 'Enter the app name', name: 'APP_NAME')
                            ]
                        )
                        echo "User Input returned: ${userInput}"
                        if (userInput['ENV'].isEmpty() || userInput['APP_NAME'].isEmpty()) {
                            error('Please provide the required details')
                        }
                        // Update our global variables
                        ENV = userInput['ENV']
                        APP_NAME = userInput['APP_NAME']
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: User Input========"
                    echo "ENV: ${ENV}"
                    echo "APP_NAME: ${APP_NAME}"
                }
                failure {
                    echo "========FAILURE: User Input========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Check bucket") {
            steps {
                script {
                    echo "========EXEC: Check bucket========"
                    try {
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 's3_backend_name']
                        ]) {
                            def fileStatus = sh(script: "aws s3 ls s3://${s3_backend_name}/envs/.env.${ENV}", returnStatus: true)
                            if (fileStatus == 0) {
                                echo "File .env.${ENV} exists in bucket."
                                def userChoice = input(
                                    message: "File .env.${ENV} already exists. Do you want to delete it?",
                                    parameters: [
                                        choice(
                                            name: 'DELETE_CHOICE',
                                            choices: "Yes\nNo",
                                            description: "Select 'Yes' to delete the file, 'No' to abort the build."
                                        )
                                    ]
                                )
                                if (userChoice == "Yes") {
                                    sh "aws s3 rm s3://${s3_backend_name}/envs/.env.${ENV}"
                                    echo "File .env.${ENV} deleted from bucket."
                                } else {
                                    error("User chose to abort and not delete the file")
                                }
                            } else {
                                echo "File .env.${ENV} does not exist. Proceeding with the pipeline."
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
                    echo "========SUCCESS: Check bucket========"
                }
                failure {
                    echo "========FAILURE: Check bucket========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Generate .env file and upload") {
            steps {
                script {
                    echo "========EXEC: Generate .env file and upload========"
                    try {
                        def userInput = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the backend image name', name: 'BACKEND_IMAGE_NAME'),
                                string(defaultValue: '', description: 'Enter the backend image repository', name: 'BACKEND_IMAGE_REPO'),
                                string(defaultValue: '', description: 'Enter the backend image version', name: 'BACKEND_IMAGE_VERSION'),
                                string(defaultValue: '', description: 'Enter the backend kinesis stream name', name: 'BACKEND_KINESIS_STREAM_NAME'),
                                string(defaultValue: '', description: 'Enter the backend aws region', name: 'BACKEND_AWS_REGION'),
                                string(defaultValue: '', description: 'Enter the backend eks cluster name', name: 'EKS_CLUSTER_NAME')
                            ]
                        )
                        echo "Generate .env file input: ${userInput}"
                        if (
                            userInput['BACKEND_IMAGE_NAME'].isEmpty() ||
                            userInput['BACKEND_IMAGE_REPO'].isEmpty() ||
                            userInput['BACKEND_IMAGE_VERSION'].isEmpty()||
                            userInput['BACKEND_KINESIS_STREAM_NAME'].isEmpty()||
                            userInput['BACKEND_AWS_REGION'].isEmpty()||
                            userInput['EKS_CLUSTER_NAME'].isEmpty()

                        ) {
                            error('Please provide the required details')
                        }
                        BACKEND_IMAGE_NAME = userInput['BACKEND_IMAGE_NAME']
                        BACKEND_IMAGE_REPO = userInput['BACKEND_IMAGE_REPO']
                        BACKEND_IMAGE_VERSION = userInput['BACKEND_IMAGE_VERSION']
                        BACKEND_KINESIS_STREAM_NAME = userInput['BACKEND_KINESIS_STREAM_NAME']
                        BACKEND_AWS_REGION = userInput['BACKEND_AWS_REGION']
                        EKS_CLUSTER_NAME = userInput['EKS_CLUSTER_NAME']

                        sh "touch .env.${ENV}"
                        sh "echo BACKEND_IMAGE_NAME=${BACKEND_IMAGE_NAME} >> .env.${ENV}"
                        sh "echo BACKEND_IMAGE_REPO=${BACKEND_IMAGE_REPO} >> .env.${ENV}"
                        sh "echo BACKEND_IMAGE_VERSION=${BACKEND_IMAGE_VERSION} >> .env.${ENV}"
                        sh "echo BACKEND_ENV=${ENV} >> .env.${ENV}"
                        sh "echo BACKEND_APP_NAME=${APP_NAME} >> .env.${ENV}"
                        sh "echo BACKEND_KINESIS_STREAM_NAME=${BACKEND_KINESIS_STREAM_NAME} >> .env.${ENV}"
                        sh "echo BACKEND_AWS_REGION=${BACKEND_AWS_REGION} >> .env.${ENV}"
                        sh "echo EKS_CLUSTER_NAME=${EKS_CLUSTER_NAME} >> .env.${ENV}"

                        echo "File .env.${ENV} created"

                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 's3_backend_name']
                        ]) {
                            sh "aws s3 cp .env.${ENV} s3://${s3_backend_name}/envs/.env.${ENV}"
                            def fileStatus = sh(script: "aws s3 ls s3://${s3_backend_name}/envs/.env.${ENV}", returnStatus: true)
                            if (fileStatus == 0) {
                                echo "File .env.${ENV} uploaded to bucket"
                            } else {
                                error("File .env.${ENV} not uploaded to bucket")
                            }
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                always {
                    sh "rm -f .env.${ENV}"
                }
                success {
                    echo "========SUCCESS: Generate .env file and upload========"
                }
                failure {
                    echo "========FAILURE: Generate .env file and upload========"
                    echo "ERROR: ${ERROR}"
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
