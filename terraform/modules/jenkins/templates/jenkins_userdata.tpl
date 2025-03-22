#!/bin/bash

echo "Updating and installing packages..."
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y

# Install Jenkins
echo "Installing Jenkins..."
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y

sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y

# Start Jenkins
echo "Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Install Terraform
echo "Installing Terraform..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Install k8s
echo "Installing k8s..."
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
echo "Installing Helm..."
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
sudo -rm -f get_helm.sh