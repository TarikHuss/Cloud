#!/bin/bash
set -e

echo "==================================="
echo "Cloud9 Setup Script"
echo "==================================="

# 1. Git konfiguracija
echo "1. Setting up Git credentials..."
git config --global user.name "TarikHuss"
git config --global user.email "tarikhusejnovic0@gmail.com"
echo "✓ Git configured"

# 2. Proveri da li repozitorij već postoji
if [ ! -d "Cloud" ]; then
    echo "2. Cloning repository..."
    git clone https://github.com/TarikHuss/Cloud.git
    echo "✓ Repository cloned"
else
    echo "2. Repository already exists, pulling latest changes..."
    cd Cloud && git pull && cd ..
    echo "✓ Repository updated"
fi

# 3. Instalacija Terraform-a
if ! command -v terraform &> /dev/null; then
    echo "3. Installing Terraform..."
    wget -q https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
    unzip -q terraform_1.5.7_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.5.7_linux_amd64.zip
    echo "✓ Terraform installed"
else
    echo "3. Terraform already installed"
    terraform --version
fi

# 4. Navigacija do terraform foldera
cd Cloud/Cloud_projekat1/terraform

# 5. Kreiranje EC2 key pair-a
echo "4. Creating EC2 key pair..."
if [ ! -f "tarik-app.pem" ]; then
    aws ec2 create-key-pair --key-name tarik-app --query 'KeyMaterial' --output text > tarik-app.pem
    chmod 400 tarik-app.pem
    echo "✓ Key pair created"
else
    echo "✓ Key pair already exists"
fi

# 6. Kreiranje terraform.tfvars ako ne postoji
if [ ! -f "terraform.tfvars" ]; then
    echo "5. Creating terraform.tfvars..."
    cat > terraform.tfvars << 'TFVARS'
aws_region   = "us-east-1"
project_name = "flask-vue-books"
github_repo  = "https://github.com/TarikHuss/Cloud.git"
db_password  = "SecurePassword123!"
instance_type = "t2.micro"
key_name = "tarik-app"
allowed_ips = ["0.0.0.0/0"]
TFVARS
    echo "✓ terraform.tfvars created"
else
    echo "5. terraform.tfvars already exists"
fi

echo ""
echo "==================================="
echo "Setup completed successfully!"
echo "==================================="
echo ""
echo "You are now in: $(pwd)"
echo ""
echo "Next steps:"
echo "1. Run: terraform init"
echo "2. Run: terraform apply -auto-approve"
echo ""
