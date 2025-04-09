@Field def ENV = ''
@Field def APP_NAME = ''
@Field def API_URL = ''
@Field def ERROR = ''

pipeline{
    agent any
    stages{
        stage("Check Environment"){
            steps {
                script {
                    echo "========EXEC: Check Environment========"
                    try {
                        // Input returns a string since there's only one parameter.
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

                        // Check if the .env file exists in S3.
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME']
                        ]) {
                            def envExists = sh(
                                script: "aws s3 ls s3://${S3_BACKEND_NAME}/envs/.env.${ENV}",
                                returnStatus: true
                            )
                            if (envExists != 0) {
                                error("File .env.${ENV} does not exist in bucket")
                            }
                        }
                        def appDetails = input(
                            message: 'Please provide the required details:',
                            parameters: [
                                string(defaultValue: '', description: 'Enter the APP name', name: 'APP_NAME'),
                                string(defaultValue: '', description: 'Enter the API url', name: 'API_URL'),
                            ]
                        )
                        echo "User Input returned: ${appDetails}"
                        if (
                            userInput['APP_NAME'].isEmpty() ||
                            userInput['API_URL'].isEmpty()
                          ){
                            error('Please provide the required details')
                            }
                            APP_NAME = appDetails['APP_NAME']
                            API_URL = appDetails['API_URL']
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Check Environment========"
                    echo "ENV: ${ENV}"
                }
                failure {
                    echo "========FAILURE: Check Environment========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Checkout code") {
            steps {
                script {
                    echo "========EXEC: Checkout code========"
                    try {
                        checkout scm
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                        ]) {
                          sh "touch ./app/frontend-app/.env.production"
                          sh "echo VITE_APP_ENV=${ENV} >> ./app/frontend-app/.env.production"
                          sh "echo VITE_APP_NAME=${APP_NAME} >> ./app/frontend-app/.env.production"
                          sh "echo VITE_API_URL=${API_URL} >> ./app/frontend-app/.env.production"
                          sh "echo VITE_APP_VERSION=0.2.0 >> ./app/frontend-app/.env.production"
                        }
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Checkout code========"
                }
                failure {
                    echo "========FAILURE: Checkout code========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Deploy Frontend"){
          script{
            try {
              echo "========EXEC: Deploy Frontend========"
              withCredentials([
                  [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
              ]) {
                sh "aws s3 cp s3://${ENV}-${APP_NAME}-app-bucket/envs/.env.${ENV} .env"
              }
              sh "make fs-build"
              sh "make fs-push"
            } catch (Exception e) {
                ERROR = e.getMessage()
                throw e
            }
          }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}