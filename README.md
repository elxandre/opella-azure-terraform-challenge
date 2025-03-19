# Opella DevOps Technical Challenge - Azure Infrastructure

This repository contains Terraform code for provisioning Azure infrastructure, developed as part of the Opella DevOps Technical Challenge. The solution demonstrates a structured approach to Infrastructure as Code (IaC) using Terraform and Azure.

## Solution Overview

The solution implements:

1. A reusable Azure VNET Terraform module with flexible configuration options
2. Multiple environment deployments (Development and Production)
3. GitHub CI/CD pipelines for infrastructure deployment
4. Code quality and security tools

## Reusable VNET Module

The VNET module (`modules/vnet/`) is designed to be highly configurable and reusable across different environments. It provides:

- Virtual Network with customizable address space
- Subnet creation with flexible configuration
- Network Security Groups with rule management
- Support for service endpoints and subnet delegations
- Optional Network Watcher flow logs with Traffic Analytics
- Comprehensive tagging system

## Environment Implementation

The solution demonstrates using the VNET module in two environments:

1. **Development** (`environments/dev/`):
   - Single region (eastus) deployment
   - Basic network configuration with app and DB subnets
   - Development VM for testing
   - Storage account for application data

2. **Production** (`environments/prod/`):
   - Multi-tier architecture with web, app, and DB subnets
   - Application Gateway with WAF protection
   - Key Vault for secrets management
   - Network security monitoring
   - Geo-redundant storage

## Environment Isolation

The solution uses Resource Groups for environment isolation, which provides:

1. **Logical Grouping**: Resources are grouped by environment and region
2. **Access Control**: Separate RBAC can be applied to each environment
3. **Cost Management**: Easy tracking of costs by environment
4. **Deployment Flexibility**: Independent deployment lifecycle for each environment

For larger organizations, using separate subscriptions would provide stronger isolation and governance controls.

## CI/CD Pipeline

The repository includes GitHub Actions workflows for:

1. **Linting & Validation** (`terraform-lint.yml`): Ensures code quality
2. **Planning** (`terraform-plan.yml`): Generates and reviews deployment plans
3. **Deployment** (`terraform-apply.yml`): Applies infrastructure changes

The release lifecycle follows GitOps practices:
- `develop` branch deploys to development environment
- `main` branch deploys to production environment
- Manual workflow triggers available for flexibility

## Code Quality Tools

The repository includes several tools to maintain code quality:

1. **Pre-commit hooks**: Catches issues before they're committed
2. **TFLint**: Terraform-specific linting
3. **Checkov**: Security and compliance scanning
4. **Terraform Docs**: Automated documentation
5. **GitLeaks**: Prevents secrets from being committed

## Tagging Strategy

Resources are tagged with:

- `Environment`: Identifies the deployment environment (dev/prod)
- `Project`: Project identifier
- `Owner`: Team responsible for the resources
- `ManagedBy`: Set to "Terraform" to identify IaC-managed resources
- `CostCenter`: (Production only) For billing purposes

## Getting Started

### Prerequisites

- Terraform >= 1.0.0
- Azure CLI
- GitHub account
- Azure subscription

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/elxandre/opella-azure-terraform-challenge.git
   cd opella-azure-terraform-challenge
   ```

2. **Set up the backend storage account**:
   ```bash
   ./scripts/setup-backend.sh
   ```

3. **Configure environment variables**:
   Copy `.env.example` to `.env` and update with your values.

### Deployment

#### Local Deployment

1. **Initialize Terraform**:
   ```bash
   cd environments/dev
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan -out=tfplan
   ```

3. **Apply the changes**:
   ```bash
   terraform apply tfplan
   ```

#### CI/CD Deployment

1. Push changes to the `develop` branch to deploy to the development environment
2. Create and merge a PR from `develop` to `main` to deploy to production

## Testing

The module includes:
- Input validation for error prevention
- Output verification for expected results
- Integration with Azure Policy for governance compliance

## Future Improvements

1. Implement Terratest for automated infrastructure testing
2. Add infrastructure monitoring with Azure Monitor
3. Integrate with a secrets management solution
4. Set up automated disaster recovery testing
5. Add infrastructure drift detection

Explaining my Process

I approached this challenge with a design-first methodology. Rather than immediately deploying resources, I carefully designed the infrastructure architecture to ensure it met all requirements for scalability, security, and maintainability.
I focused on creating a robust, reusable VNET module that handles various networking configurations. The module was designed with flexibility in mind, supporting both simple development environments and complex production setups.
I tested the Terraform code locally using terraform validate and terraform plan to ensure correct syntax and resource configurations without actually creating resources in Azure.

The terraform plan output was generated using the following approach:

I set up my local environment with the Azure CLI and authenticated to my Azure account
I ran terraform init to initialize the Terraform configuration
I used terraform plan -out=tfplan to generate the execution plan without applying it
I then converted this plan to human-readable format with terraform show -no-color tfplan > terraform-plan-output.md

This approach allowed me to verify the configuration accuracy and demonstrate what would be deployed without actually consuming Azure resources or incurring costs.
Although I didn't deploy the actual infrastructure, I implemented several validation techniques:

Static code analysis with TFLint to catch potential issues
Security scanning with Checkov to identify security misconfigurations
Terraform's built-in validation to ensure resource configurations were valid
Created test cases with Terratest that could be used to verify the infrastructure if deployed
