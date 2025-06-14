# Terraform AWS EKS Managed
![Project Diagram](./Architecture.png)
This project provides Terraform configurations to set up and manage an AWS EKS (Elastic Kubernetes Service) cluster. The EKS cluster serves as the foundation for deploying containerized applications, enabling scalability, high availability, and integration with AWS services.

## Project Structure

- **Terraform Configurations**: Includes modules and resources to provision the EKS cluster, node groups, and associated AWS infrastructure.
- **chart/my-app**: Contains Helm chart for deploying applications on the EKS cluster.

### Key Components
- **EKS Cluster**
- **Node Groups**: EC2 instances configured as worker nodes.
- **IAM Roles**: Roles and policies for EKS, worker nodes, and Kubernetes services.

## Usage

1. **Provide Variable Values**:
   Create a `terraform.tfvars` file 

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the Infrastructure**:
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**:
   ```bash
   terraform apply
   ```

5. **Access the Cluster**:
   Configure `kubectl` to connect to the EKS cluster:
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name>
   ```

6. **Deploy Applications**:
   Use Helm or `kubectl` to deploy applications to the cluster.

## Prerequisites

- **Terraform**: Installed and configured.
- **AWS CLI**: Installed and authenticated.
- **kubectl**: Installed for Kubernetes management.

## Notes

- Customize the node group instance types and scaling parameters as needed.
- Use the `chart/my-app/values.yaml` file for deploying sample applications if required.
- Sensitive values like AWS credentials should not be hardcoded and must be securely managed.
