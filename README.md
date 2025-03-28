# DevOps e-Commerce Scalable Web App

## Introduction

![Architecture](./assets/architecture.png)

## Prerequisites

- AWS IAM User
- AWS CLI
- S3 Backend bucket

## Setup

0. Define the aws cli profile for the AWS IAM User, **IMPORTANT** The same user needs to be used in the CI/CD pipelines in jenkins.

```bash
aws configure --profile e-commerce
```

1. Apply the terraform infra

```bash
make tf-apply
```

2. Get the Jenkins IP from the outputs

```bash
app_bucket_name = ""
eks_cluster_endpoint = ""
eks_cluster_name = ""
eks_cluster_oidc_issuer_url = ""
firehose_delivery_stream_arn = ""
jenkins_ip = "<jenkins-ip>"
kinesis_stream_arn = ""
vpc_id = ""
```

3. Open the Jenkins UI in the browser `http://<jenkins-ip>:8080`
   ![Jenkins UI](./assets/jenkins-unlock.png)

4. SSH into the Jenkins instance and cat the initial admin password

```bash
ssh ec2-user@<jenkins-ip>
cat /var/lib/jenkins/secrets/initialAdminPassword
```

5. Setup a jenkins user and install the default plugins

6. Install AWS Credentials Plugin
   ![AWS Credentials Plugin](./assets/jenkins-aws-creds.png)

7. Setup AWS credentials and s3 bucket as secrets, it is important to use the, AWS Credentials type ID: `aws_credentials` and secret text type with the ID: `s3_backend_name`.
   ![AWS Credentials Plugin](./assets/jenkins-global-creds.png)

8. Create a new jenkins pipeline and point it to the `ci/generate-env.Jenkinsfile` file.

9. Build the pipeline and provide the required details.
