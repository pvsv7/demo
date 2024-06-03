#!/bin/bash

# Function to install AWS CLI
install_aws_cli() {
    echo "Installing AWS CLI..."
    sudo apt update > /dev/null
    sudo apt install unzip -y > /dev/null
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null
    unzip -o awscliv2.zip > /dev/null
    sudo ./aws/install > /dev/null
}

# Function to install eksctl
install_eksctl() {
    echo "Installing eksctl..."
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp > /dev/null
    sudo mv /tmp/eksctl /usr/local/bin
}

# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /dev/null
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin
}

# Main function
main() {
    install_aws_cli
    install_eksctl
    install_kubectl

    echo "Versions installed:"
    aws --version
    eksctl version
    kubectl version --client
}

# Execute main function
main
