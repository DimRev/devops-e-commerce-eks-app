# DevOps e-Commerce Scalable Web App

## Introduction

![Architecture](./assets/overview.png)

## Prerequisites

- AWS IAM User
- AWS CLI
- S3 Backend bucket

## Setup

0. Define the aws cli profile for the AWS IAM User, **IMPORTANT** The same user needs to be used in the CI/CD pipelines in jenkins.

```bash
aws configure --profile e-commerce
```

This is important as Terraform will use the e-commerce profile to create the EKS cluster and give that profile EKSAdmin privileges.

1. Apply the terraform infra

```bash
make tf-apply
```

2. Get the Jenkins IP from the outputs

```bash
#outputs:
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

10. Follow the pipeline to create the `.env` file for the required env to your backend s3 bucket.

11. Create a new jenkins pipeline and point it to the `ci/backend-helm-install-or-upgrade.Jenkinsfile` file.

12. Build the pipeline and provide the required details, This pipeline will deploy the required helm charts inside cluster, or updated them if they already exist.

13. Inside the `app/frontend-app` create a `.env.production` file with the details from the [.env.example](./app/frontend-app/.env.example) file **IMPORTANT** the `VITE_API_URL` should point to the backend loadbalancer endpoint via http.

14. use pnpm@10 to install frontend dependencies, if you're using npm 18 +, simply use `npm i -g pnpm@10` to install pnpm.

15. Deploy the frontend app to the S3 bucket using `frontend-deploy.sh` script.

## Production Enhancements

To move this demo towards a production-ready setup, consider the following changes:

### Frontend (S3 via CloudFront)

1.  **Create CloudFront Distribution:** Set up an AWS CloudFront distribution.
2.  **Configure S3 Origin:** Point the CloudFront distribution's origin to the `S3_app` bucket.
3.  **Restrict S3 Bucket Access:** Remove public access from the S3 bucket. Use CloudFront Origin Access Identity (OAI) or Origin Access Control (OAC) to allow CloudFront to securely read from the bucket.
4.  **Enable HTTPS:** Attach an AWS Certificate Manager (ACM) SSL/TLS certificate to the CloudFront distribution for your custom domain.
5.  **Set Root Object:** Configure the CloudFront distribution's default root object to `index.html`.

### Backend (EKS Load Balancer with HTTPS)

1.  **Provision Certificate:** Create or import an SSL/TLS certificate for your backend's custom domain using AWS Certificate Manager (ACM).
2.  **Configure Load Balancer Listener:** Modify the AWS Load Balancer (ALB/NLB) serving the EKS service:
    - Add an HTTPS listener on port 443.
    - Associate the ACM certificate with this listener.
    - Configure the listener to forward traffic to the target group pointing to your EKS pods (likely on HTTP, as TLS terminates at the LB).
3.  **Update Frontend Configuration:** Ensure the frontend application makes API requests to the new HTTPS endpoint (`https://your-api-domain.com`).

### DNS

- Update your DNS records (e.g., using Route 53) to point your custom domain(s) to the CloudFront distribution (for the frontend) and the Load Balancer (for the backend API).
