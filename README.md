# Burger Builder Platform

## Secure Multi-Environment Azure Deployment with CI/CD, Terraform, Ansible, Docker, SonarQube, and HTTPS

Burger Builder Platform is a full-stack web application deployed on Azure using a production-inspired DevOps architecture.

The goal of this project was not only to deploy an application, but to build a controlled and repeatable delivery platform. The solution includes separate Development and Production environments, automated CI/CD pipelines, Infrastructure as Code, server configuration automation, code quality checks, custom HTTPS domains, and private database access.

---

## Live URLs

| Environment | URL | Purpose |
|---|---|---|
| Production | https://burgerapp.live | Main production application |
| Production alias | https://www.burgerapp.live | WWW production alias |
| Development | https://dev.burgerapp.live | Development environment |
| SonarQube | https://sonar.burgerapp.live | Code quality dashboard |

---

## Project Objectives

The main objectives of this project were:

- Deploy a full-stack web application on Azure.
- Use separate Development and Production environments.
- Avoid direct deployment to Production.
- Automate infrastructure provisioning with Terraform.
- Automate VM configuration and application deployment with Ansible.
- Use Docker for frontend and backend deployment.
- Use Azure Application Gateway WAF as the secure public entry point.
- Enable HTTPS with a custom domain.
- Store secrets and TLS certificates in Azure Key Vault.
- Use Azure SQL Database with private access.
- Integrate SonarQube quality checks into CI/CD.
- Use GitHub Actions as the main automation platform.

---

## What Makes This Project Different

Instead of using a single environment and deploying directly to production, this project uses a staged delivery model:

```text
Developer Code
    |
    v
Pull Request
    |
    v
Development Environment
    |
    v
Manual Validation / Quality Checks
    |
    v
Main Branch
    |
    v
Production Environment
```

This is closer to how real teams release software. Development acts like a test kitchen where changes are validated before being served to real users in Production.

---

## High-Level Architecture

```text
Users / Browsers
        |
        v
Name.com DNS
        |
        v
Azure Application Gateway WAF v2
        |
        |-- /        -> Frontend VM running Docker + Nginx
        |
        |-- /api/*   -> Backend VM running Docker + Spring Boot
                              |
                              v
                       Azure SQL Database
                       via Private Endpoint
```

Supporting services:

```text
GitHub Actions
  -> Terraform
  -> Ansible
  -> Azure Container Registry
  -> SonarQube
  -> Azure VMs

Azure Key Vault
  -> Backend secrets
  -> TLS certificates for Application Gateway

Azure Monitor / Log Analytics
  -> Logs
  -> Metrics
  -> Alerts
```

Architecture diagram:

```text
docs/architecture-diagram.png
```

---

## Environment Design

### Development Environment

The Development environment is used for testing and validation before production release.

Main components:

- Azure Resource Group for Dev
- Dev VNet
- Azure Application Gateway WAF v2
- Frontend Linux VM
- Backend Linux VM
- Self-hosted GitHub Actions runner VM
- SonarQube VM
- Azure SQL Database
- SQL Private Endpoint
- Azure Key Vault
- Key Vault Private Endpoint
- Azure Bastion
- Log Analytics and Azure Monitor alerts

URL:

```text
https://dev.burgerapp.live
```

SonarQube:

```text
https://sonar.burgerapp.live
```

### Production Environment

The Production environment is used for the live application.

Main components:

- Azure Resource Group for Prod
- Prod VNet
- Azure Application Gateway WAF v2
- Frontend Linux VM
- Backend Linux VM
- Self-hosted GitHub Actions runner VM
- Azure SQL Database
- SQL Private Endpoint
- Azure Key Vault
- Key Vault Private Endpoint
- Azure Bastion
- Log Analytics and Azure Monitor alerts

URLs:

```text
https://burgerapp.live
https://www.burgerapp.live
```

### Shared Services

Shared services are used by both environments.

Main shared component:

- Azure Container Registry

The shared ACR stores Docker images for both frontend and backend services.

---

## Technology Stack

### Frontend

- React
- TypeScript
- Vite
- Nginx
- Docker

### Backend

- Java 21
- Spring Boot
- Maven
- Azure SQL Database
- Docker

### DevOps and Cloud

- Azure
- Terraform
- Ansible
- GitHub Actions
- Azure Container Registry
- Azure Application Gateway WAF v2
- Azure Key Vault
- Azure SQL Database
- Azure Bastion
- Azure Monitor
- Log Analytics
- SonarQube
- Let’s Encrypt / Certbot
- Name.com DNS

---

## CI/CD Workflows

The project uses three main GitHub Actions workflows.

### 1. Platform Provision and Configure

Workflow:

```text
.github/workflows/platform.yml
```

Purpose:

- Runs Terraform plan/apply.
- Provisions Azure infrastructure.
- Configures VMs using Ansible.
- Installs and configures Docker.
- Prepares Dev and Prod environments.

### 2. Backend CI/CD

Workflow:

```text
.github/workflows/backend-ci-cd.yml
```

Purpose:

- Builds backend with Maven.
- Runs SonarQube scan.
- Builds backend Docker image.
- Pushes backend image to Azure Container Registry.
- Deploys backend container to Dev or Prod using Ansible.

### 3. Frontend CI/CD

Workflow:

```text
.github/workflows/frontend-ci-cd.yml
```

Purpose:

- Installs frontend dependencies.
- Runs frontend lint/test/build.
- Runs SonarQube scan.
- Builds frontend Docker image.
- Pushes frontend image to Azure Container Registry.
- Deploys frontend container to Dev or Prod using Ansible.

---

## Branching and Promotion Strategy

The project uses a staged release process:

```text
feature branch
    |
    v
Pull Request to dev
    |
    v
Development deployment and validation
    |
    v
Pull Request from dev to main
    |
    v
Production deployment
```

Important team rule:

```text
Do not mix infrastructure/configuration changes and application code changes in the same pull request.
```

Reason:

- Platform workflows and application workflows may run independently.
- Separating changes reduces race conditions.
- Troubleshooting becomes easier.
- Each PR has a clearer purpose.

---

## Security Highlights

Security decisions:

- Azure Application Gateway WAF v2 is the only public application entry point.
- Frontend and backend VMs do not expose public IP addresses.
- Azure SQL is accessed privately through a Private Endpoint.
- Application secrets are stored in Azure Key Vault.
- TLS certificates are stored in Azure Key Vault and used by Application Gateway.
- Managed identities and RBAC are used for Azure resource access.
- Azure Bastion is used for secure VM administration.
- GitHub Secrets store CI/CD-sensitive values.
- SonarQube validates code quality before deployment.

---

## Key Vault Usage

Key Vault stores:

- Backend database URL
- Backend database username
- Backend database password
- TLS certificate for Application Gateway

Backend deployment flow:

```text
Azure Key Vault
    |
    v
Ansible reads secrets during deployment
    |
    v
Protected .env file on backend VM
    |
    v
Docker Compose starts backend container
    |
    v
Spring Boot reads environment variables
```

Certificate flow:

```text
Let’s Encrypt / Certbot
    |
    v
PFX certificate
    |
    v
Azure Key Vault
    |
    v
Application Gateway HTTPS listener
```

---

## SonarQube

SonarQube is used for code quality validation.

URL:

```text
https://sonar.burgerapp.live
```

Integrated with:

- Backend CI/CD
- Frontend CI/CD

SonarQube checks:

- Reliability
- Security
- Maintainability

The Quality Gate is intentionally demo-friendly, so it catches serious issues without blocking the demo because of strict coverage requirements.

---

## Validation URLs

Production:

```text
https://burgerapp.live
https://www.burgerapp.live
https://burgerapp.live/api/ingredients
```

Development:

```text
https://dev.burgerapp.live
https://dev.burgerapp.live/api/ingredients
```

SonarQube:

```text
https://sonar.burgerapp.live
```

---

## Quick Smoke Test Commands

Production:

```powershell
curl.exe -I "https://burgerapp.live"
curl.exe -I "https://www.burgerapp.live"
curl.exe -I "https://burgerapp.live/api/ingredients"
```

Development:

```powershell
curl.exe -I "https://dev.burgerapp.live"
curl.exe -I "https://dev.burgerapp.live/api/ingredients"
```

SonarQube:

```powershell
curl.exe -I "https://sonar.burgerapp.live"
```

Backend VM health check:

```bash
curl -i http://localhost:8080/actuator/health
```

Docker container check:

```bash
docker ps
```

---

## Summary

This project demonstrates a realistic DevOps delivery platform rather than a simple cloud deployment.

Main achievements:

- Secure Azure architecture
- Separate Dev and Prod environments
- Automated infrastructure with Terraform
- Automated server configuration with Ansible
- Dockerized frontend and backend
- GitHub Actions CI/CD
- SonarQube quality scanning
- HTTPS custom domains
- Private database access
- Key Vault based secret and certificate management
