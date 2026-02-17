# 🚀 CloudDevOpsProject

End-to-End DevOps Project implementing:

* Docker Containerization
* Kubernetes Orchestration
* Terraform Infrastructure (AWS)
* Ansible Configuration Management
* Jenkins CI Pipeline
* ArgoCD CD Deployment

---

# 📌 1️⃣ Clone Repository

```bash
git clone https://github.com/<your-username>/CloudDevOpsProject.git
cd CloudDevOpsProject
```

Clone Application Source Code:

```bash
git clone https://github.com/Ibrahim-Adel15/FinalProject.git
```

---

# 🐳 2️⃣ Docker – Build & Run Application

## 🔹 Build Docker Image

```bash
docker build -t <your-dockerhub-username>/ivolve-app:latest .
```

## 🔹 Run Container Locally

```bash
docker run -d -p 8080:8080 <your-dockerhub-username>/ivolve-app:latest
```

Open in browser:

```
http://localhost:8080
```

---

## 🔹 Push Image to DockerHub

Login first:

```bash
docker login
```

Push image:

```bash
docker push <your-dockerhub-username>/ivolve-app:latest
```

---

# ☸️ 3️⃣ Kubernetes Deployment

## 🔹 Create Namespace

```bash
kubectl create namespace ivolve
```

## 🔹 Apply Manifests

```bash
kubectl apply -f k8s/
```

Check resources:

```bash
kubectl get all -n ivolve
```
---

## **Kubernetes Setup (kubeadm)**

### **Cluster Setup**

* **Master Node**: initialize the cluster

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

* Set up kubeconfig for kubectl:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

* **Worker Node**: join the cluster

```bash
sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

### **Networking**

Install a pod network (e.g., Flannel):

```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

---

## **Deploying the Application**

1. Switch kubectl context to master node.
2. Apply Kubernetes manifests:

```bash
kubectl apply -f deployment.yaml -n ivolve
kubectl apply -f service.yaml -n ivolve
```

3. Check pod status:

```bash
kubectl get pods -n ivolve
```
---

# **CloudDevOpsProject – Terraform Module**

---

## **Prerequisites**

Before running Terraform, make sure you have:

* Terraform >= 1.5.x installed
* AWS CLI installed and configured
* An AWS account with permissions to create VPC, Subnets, EC2, and S3
* (Optional) SSH key configured for EC2 instances



## **AWS S3 Backend Configuration**

Terraform uses **S3** to store remote state. Make sure you create the bucket before initializing Terraform:

```bash
aws s3api create-bucket --bucket ivolve-terraform-state-rawan-123 --region us-east-1
```

`backend.tf` example:

```hcl
terraform {
  backend "s3" {
    bucket = "ivolve-terraform-state-rawan-123"
    key    = "clouddevopsproject/terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

## **Input Variables**

Defined in `variables.tf`:

| Variable Name | Description          | Default   |
| ------------- | -------------------- | --------- |
| aws_region    | AWS region to deploy | us-east-1 |
| key_name      | SSH key name for EC2 | vockey    |

> Note: `key_name` must exist in your AWS account.

---

## **Outputs**

After applying Terraform, the following outputs are available:

| Output Name         | Description                  |
| ------------------- | ---------------------------- |
| vpc_id              | The VPC ID created           |
| public_subnets      | List of public subnet IDs    |
| igw_id              | Internet Gateway ID          |
| server_instance_ids | IDs of EC2 instances created |

---

## **Usage**

1. **Initialize Terraform:**

```bash
terraform init
```

2. **Plan the deployment:**

```bash
terraform plan
```

3. **Apply the deployment:**

```bash
terraform apply
```

# **Ansible Configuration Management**

This directory contains Ansible playbooks and roles used to configure AWS EC2 instances for the DevOps environment.

The configuration includes:
 • Installing required packages (Git, Docker, Java)
 • Installing and configuring Jenkins
 • Using Ansible Roles
 • Using Dynamic Inventory with AWS EC2
 • Preparing the server for CI/CD pipeline execution

⸻

⚙️ Prerequisites

Make sure you have the following installed:
 • Python 3
 • pip
 • Virtual Environment (recommended)
 • Ansible
 • AWS CLI configured
 • SSH key for EC2 access

⸻

🐍 Setup Python Virtual Environment

python3 -m venv venv
source venv/bin/activate

Install required dependencies:

pip install -r requirements.txt

Example requirements.txt:

ansible
boto3
botocore


⸻

🔐 AWS Authentication

Make sure AWS credentials are configured:

aws configure

Or environment variables:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION


⸻

📡 Dynamic Inventory

This project uses Ansible AWS EC2 dynamic inventory.

File: inventory_aws_ec2.yaml

Example:

plugin: amazon.aws.aws_ec2
regions:
  - us-east-1

filters:
  tag:Name: jenkins-server

keyed_groups:
  - key: tags.Name
    prefix: tag

Test inventory:

ansible-inventory -i inventory_aws_ec2.yaml --list


⸻

🚀 Running the Playbook

Run configuration:

ansible-playbook -i inventory_aws_ec2.yaml playbook.yaml


⸻

🧱 Roles Description

Common Role

Installs base packages:
 • Git
 • Curl
 • Required utilities

Docker Role

Installs and configures Docker:
 • Docker Engine
 • Docker service enable & start
 • Add user to docker group

Jenkins Role

Installs Jenkins:
 • Java installation
 • Jenkins repository
 • Jenkins service enable & start

⸻

🔎 Verify Installation

SSH into the server:

ssh -i key.pem ec2-user@PUBLIC_IP

Check services:

docker --version
jenkins --version
systemctl status jenkins


⸻

🌐 Jenkins Access

Default Jenkins URL:

http://PUBLIC_IP:8080

Get initial admin password:

sudo cat /var/lib/jenkins/secrets/initialAdminPassword


⸻

🛠 Troubleshooting

Permission denied (SSH)

Make sure key permissions are correct:

chmod 400 key.pem

Dynamic inventory not working

Install required collection:

ansible-galaxy collection install amazon.aws


# ** Jenkins README**

Jenkins CI Pipeline

This directory contains Jenkins pipeline configuration used for Continuous Integration (CI) in the Cloud DevOps Project.

The pipeline automates:
 • Building Docker image
 • Scanning Docker image
 • Pushing image to Docker registry
 • Removing local image
 • Updating Kubernetes manifests
 • Pushing manifests to Git repository

It also uses Jenkins Shared Library for reusable pipeline logic.


⸻

⚙️ Prerequisites

Before running Jenkins pipeline:
 • Jenkins installed on EC2
 • Docker installed on Jenkins server
 • Git installed
 • Access to Docker Hub (or private registry)
 • Kubernetes manifests repository configured
 • Credentials added in Jenkins

⸻

🔐 Jenkins Credentials

Add the following credentials inside Jenkins:

Docker Hub Credentials

Type: Username / Password

ID example:

docker-creds

Git Credentials

For pushing manifests updates.

⸻

🚀 Pipeline Stages

The pipeline contains the following stages:

1️⃣ Build Image

Build Docker image from Dockerfile.

docker build -t image-name .

2️⃣ Scan Image

Scan container image for vulnerabilities using tools like:
 • Trivy
 • Docker Scout

3️⃣ Push Image

Push image to Docker registry.

docker push repo/image:tag

4️⃣ Delete Local Image

Cleanup Jenkins disk space.

docker rmi image

5️⃣ Update Kubernetes Manifests

Update deployment image tag automatically.

6️⃣ Push Manifests

Push updated manifests to Git repository.

⸻

🧱 Shared Library

Shared library functions are located in:

vars/

Each Groovy file represents reusable pipeline logic.

Example usage in Jenkinsfile:

@Library('my-shared-lib') _

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                buildImage()
            }
        }
    }
}


⸻

▶️ Running Pipeline
 1. Open Jenkins dashboard
 2. Create new Pipeline job
 3. Connect Git repository
 4. Select Jenkinsfile path
 5. Run Build

⸻

🌐 Jenkins Access

Default Jenkins URL:

http://SERVER_IP:8080


⸻

🛠 Troubleshooting

Docker permission issue

Add Jenkins user to docker group:

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

Pipeline cannot push to Git

Check credentials and access token.

⸻

ArgoCD Continuous Deployment

This directory contains ArgoCD configuration used for Continuous Deployment (CD) in the Cloud DevOps Project.

ArgoCD implements GitOps workflow to automatically deploy the application into the Kubernetes cluster.

⸻

📁 Directory Structure

argocd/
│── application.yaml


⸻

⚙️ Prerequisites

Before configuring ArgoCD:
 • Kubernetes cluster running (kubeadm)
 • kubectl configured
 • ArgoCD installed in cluster
 • Git repository containing Kubernetes manifests

⸻

🚀 Install ArgoCD

Create namespace:

kubectl create namespace argocd

Install ArgoCD:

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Wait for pods:

kubectl get pods -n argocd


⸻

🔐 Access ArgoCD UI

Port forward:

kubectl port-forward svc/argocd-server -n argocd 8080:443

Access:

https://localhost:8080

Get admin password:

kubectl get secret argocd-initial-admin-secret -n argocd -o yaml

Decode:

echo PASSWORD | base64 -d


⸻

📦 Application Deployment

Application file:

application.yaml

Example:

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-app
  namespace: argocd
spec:
  project: default

  source:
repoURL: https://github.com/your-repo/CloudDevOpsProject.git
    targetRevision: HEAD
    path: kubernetes

  destination:
    server: https://kubernetes.default.svc
    namespace: ivolve

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

Apply:

kubectl apply -f application.yaml


⸻

🔄 GitOps Workflow
 1. Developer pushes code
 2. Jenkins builds image and updates manifests
 3. Git repository updated
 4. ArgoCD detects changes
 5. Application automatically deployed

⸻

🔎 Verify Deployment

Check ArgoCD:

kubectl get applications -n argocd

Check pods:

kubectl get pods -n ivolve


⸻

🛠 Troubleshooting

Application not syncing

Check:

kubectl describe application devops-app -n argocd

Repo access issue

Verify repository URL and credentials.

⸻

# 👩‍💻 Author
 -Rawan Osama
