#!/bin/bash

# Exit on any error
set -e

# Update system
sudo yum update -y

# Install Java 17 (Amazon Corretto)
sudo yum install java-17-amazon-corretto -y

# Install Python 3 and pip3
sudo yum install python3 -y

# Ensure pip3 is installed (usually comes with python3, but let's be explicit)
sudo yum install python3-pip -y 

# Install virtualenv if not already installed
sudo pip3 install virtualenv

# Create a virtual environment for security tools
sudo python3 -m venv /opt/security-tools-env

# Activate the environment and install tools
source /opt/security-tools-env/bin/activate
sudo pip install checkov  # Install your tools here
deactivate

#sudo pip3 install checkov --ignore-installed requests

# Add Jenkins repository and import the latest GPG key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
sudo yum install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform

# Install Security Tools

# tfsec (now part of Trivy, skipping standalone install)
# Install Checkov (requires pip3, now ensured by Python 3 installation)
# sudo pip3 install checkov

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin

# Install Snyk (requires Node.js)
sudo yum install -y nodejs npm
sudo npm install -g snyk

# Install Gitleaks
curl -LO https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz
sudo tar -xzvf gitleaks_8.18.2_linux_x64.tar.gz -C /usr/local/bin


# Restart Jenkins to apply changes
sudo systemctl restart jenkins
echo "Installation completed successfully!"