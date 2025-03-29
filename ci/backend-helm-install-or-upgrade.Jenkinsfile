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
                    } catch (Exception e) {
                        ERROR = e.getMessage()
                        throw e
                    }
                }
            }
            post {
                success {
                    echo "========SUCCESS: Setup Environment========"
                    echo "ENV: ${ENV}"
                }
                failure {
                    echo "========FAILURE: Setup Environment========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Configure AWS CLI") {
            steps {
                script {
                    echo "========EXEC: Configure AWS CLI========"
                    // Write credentials and config to temporary files so that AWS CLI can locate them.
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']
                    ]) {
                        // Create ~/.aws directory if it doesn't exist.
                        sh "mkdir -p ~/.aws"
                        // Write credentials to ~/.aws/credentials using the temporary profile 'jenkins-temp'
                        sh """
                        cat > ~/.aws/credentials <<EOF
[e-commerce]
aws_access_key_id=\$AWS_ACCESS_KEY_ID
aws_secret_access_key=\$AWS_SECRET_ACCESS_KEY
EOF
                        """

                        sh """
                        cat > ~/.aws/config <<EOF
[profile e-commerce]
region=\$AWS_DEFAULT_REGION
output=json
EOF
                        """
                    }
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
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME']
                        ]) {
                            sh "aws s3 cp s3://${S3_BACKEND_NAME}/envs/.env.${ENV} .env"
                            def appNameValue = sh(
                                script: "cat .env | grep BACKEND_APP_NAME | cut -d '=' -f 2",
                                returnStdout: true
                            ).trim()
                            if (appNameValue == null || appNameValue.trim().isEmpty()) {
                                error("BACKEND_APP_NAME not found in .env file")
                            }
                            APP_NAME = appNameValue
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
        stage("Connect to EKS") {
            steps {
                script {
                    echo "========EXEC: Connect to EKS========"
                    try {
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials'],
                            [$class: 'StringBinding', credentialsId: 's3_backend_name', variable: 'S3_BACKEND_NAME']
                        ]) {
                            sh "aws s3 cp s3://${S3_BACKEND_NAME}/envs/.env.${ENV} .env"
                            def eksClusterNameValue = sh(
                                script: "cat .env | grep EKS_CLUSTER_NAME | cut -d '=' -f 2",
                                returnStdout: true
                            ).trim()
                            def eksClusterRegionValue = sh(
                                script: "cat .env | grep BACKEND_AWS_REGION | cut -d '=' -f 2",
                                returnStdout: true
                            ).trim()

                            if (eksClusterNameValue == null || eksClusterNameValue.trim().isEmpty()) {
                                error("EKS_CLUSTER_NAME not found in .env file")
                            }
                            if (eksClusterRegionValue == null || eksClusterRegionValue.trim().isEmpty()) {
                                error("BACKEND_AWS_REGION not found in .env file")
                            }
                            // Use the temporary profile to update kubeconfig.
                            sh "aws eks update-kubeconfig --name ${eksClusterNameValue} --region ${eksClusterRegionValue} --profile e-commerce"

                            sh "kubectl config get-contexts"
                            timeout(time: 30, unit: 'SECONDS') {
                                sh "kubectl get nodes"
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
                    echo "========SUCCESS: Connect to EKS========"
                }
                failure {
                    echo "========FAILURE: Connect to EKS========"
                    echo "ERROR: ${ERROR}"
                }
            }
        }
        stage("Install or Upgrade Helm Chart") {
            steps {
                script {
                    echo "========EXEC: Install or Upgrade Helm Chart========"
                    try {
                        ENV = ENV.toLowerCase().replace('_', '-')
                        APP_NAME = APP_NAME.toLowerCase().replace('_', '-')

                        def helmReleaseExists = sh(
                            script: "helm list | grep ${ENV}-${APP_NAME}-chart",
                            returnStatus: true
                        )
                        if (helmReleaseExists != 0) {
                            sh "chmod +x ./scripts/backend-helm-install.sh"
                            sh "./scripts/backend-helm-install.sh"
                        } else {
                            sh "chmod +x ./scripts/backend-helm-upgrade.sh"
                            sh "./scripts/backend-helm-upgrade.sh"
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
                    echo "========SUCCESS: Install or Upgrade Helm Chart========"
                }
                failure {
                    echo "========FAILURE: Install or Upgrade Helm Chart========"
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
        // Clean up the temporary AWS configuration after the pipeline runs.
        always {
            script {
                echo "========CLEANUP: Removing temporary AWS CLI configuration========"
                sh "rm -f ~/.aws/credentials ~/.aws/config"
            }
        }
    }
}
