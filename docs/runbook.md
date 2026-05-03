# Burger Builder Platform Runbook

## Purpose

This runbook explains how to operate, validate, deploy, troubleshoot, and maintain the Burger Builder Platform.

The platform is deployed on Azure with separate Development and Production environments. Infrastructure is provisioned with Terraform, server configuration and deployment are handled by Ansible, and application delivery is automated through GitHub Actions.

---

## 1. Environment Overview

### Production

| Item | Value |
|---|---|
| Application URL | `https://burgerapp.live` |
| WWW Alias | `https://www.burgerapp.live` |
| Resource Group | `rg-g6-burger-prod-plc` |
| VNet | `vnet-g6-burger-prod-plc` |
| Application Gateway | `agw-g6-burger-prod-plc` |
| Key Vault | `kv-g6-burger-prod-plc` |
| SQL Server | `sql-g6-burger-prod-plc` |
| SQL Database | `sqldb-g6-burger-prod-plc` |
| Runner VM | `vm-runner-g6-burger-prod-plc-01` |

### Development

| Item | Value |
|---|---|
| Application URL | `https://dev.burgerapp.live` |
| SonarQube URL | `https://sonar.burgerapp.live` |
| Resource Group | `rg-g6-burger-dev-plc` |
| VNet | `vnet-g6-burger-dev-plc` |
| Application Gateway | `agw-g6-burger-dev-plc` |
| Key Vault | `kv-g6-burger-dev-plc` |
| SQL Server | `sql-g6-burger-dev-plc` |
| SQL Database | `sqldb-g6-burger-dev-plc` |
| Runner VM | `vm-runner-g6-burger-dev-plc-01` |
| SonarQube VM | `vm-sonar-g6-burger-dev-plc-01` |

### Shared

| Item | Value |
|---|---|
| Shared Resource Group | `rg-g6-burger-shared-plc` |
| Azure Container Registry | Shared ACR for frontend and backend images |
| Terraform State Resource Group | `rg-g6-tfstate-plc` |
| Terraform State Storage Account | `stg6tfstateplc` |
| Terraform State Container | `tfstate` |

---

## 2. Repository Structure

```text
backend/
frontend/
infra/
  terraform/
    envs/
      shared/
      dev/
      prod/
    modules/
config/
  ansible/
    inventories/
      dev/
      prod/
    playbooks/
    roles/
.github/
  workflows/
docs/
```

Important files:

```text
.github/workflows/platform.yml
.github/workflows/backend-ci-cd.yml
.github/workflows/frontend-ci-cd.yml

infra/terraform/envs/shared
infra/terraform/envs/dev
infra/terraform/envs/prod

config/ansible/playbooks/site-dev.yml
config/ansible/playbooks/site-prod.yml
config/ansible/playbooks/backend.yml
config/ansible/playbooks/frontend.yml
```

---

## 3. Branching and Promotion Model

The project follows a staged delivery model:

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

Team rule:

```text
Do not mix infrastructure/configuration changes and application code changes in the same PR.
```

Reason:

- Platform and application workflows can run independently.
- Mixing infra and app changes can create race conditions.
- Smaller PRs are easier to review and troubleshoot.

---

## 4. GitHub Actions Workflows

### 4.1 Platform Provision and Configure

Workflow:

```text
.github/workflows/platform.yml
```

Purpose:

- Terraform plan/apply
- Infrastructure provisioning
- Ansible syntax validation
- Server configuration
- Docker installation and base VM setup

Triggered by:

- Pull request to `dev` or `main`
- Push to `dev` or `main`
- Manual dispatch

Expected behavior:

| Event | Behavior |
|---|---|
| PR to `dev` | Terraform plan for Dev, Ansible syntax check |
| Push to `dev` | Terraform apply for Dev, Ansible configure Dev |
| PR to `main` | Terraform plan for Prod, Ansible syntax check |
| Push to `main` | Terraform apply for Prod, Ansible configure Prod |

### 4.2 Backend CI/CD

Workflow:

```text
.github/workflows/backend-ci-cd.yml
```

Purpose:

- Build Java backend with Maven
- Run SonarQube scan
- Build Docker image
- Push Docker image to ACR
- Deploy backend with Ansible

Expected behavior:

| Event | Behavior |
|---|---|
| PR to `dev` or `main` | Build, scan, Docker build validation only |
| Push to `dev` | Build, scan, push image, deploy to Dev |
| Push to `main` | Build, scan, push image, deploy to Prod |

### 4.3 Frontend CI/CD

Workflow:

```text
.github/workflows/frontend-ci-cd.yml
```

Purpose:

- Install Node dependencies
- Run frontend validation
- Run SonarQube scan
- Build Docker image
- Push Docker image to ACR
- Deploy frontend with Ansible

Expected behavior:

| Event | Behavior |
|---|---|
| PR to `dev` or `main` | Build, scan, Docker build validation only |
| Push to `dev` | Build, scan, push image, deploy to Dev |
| Push to `main` | Build, scan, push image, deploy to Prod |

---

## 5. Required GitHub Variables and Secrets

### Variables

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID

LOCATION
ACR_NAME
ACR_SKU

ADMIN_USERNAME
SSH_PUBLIC_KEY

FRONTEND_VM_SIZE
BACKEND_VM_SIZE
RUNNER_VM_SIZE
SONARQUBE_VM_SIZE

SQL_ADMIN_USERNAME
SQL_DATABASE_SKU

ALERT_EMAIL
VM_CPU_ALERT_THRESHOLD
SQL_DTU_ALERT_THRESHOLD

SONAR_HOST_URL
SHARED_RESOURCE_GROUP_NAME
```

### Secrets

```text
ANSIBLE_SSH_PRIVATE_KEY
DEV_SQL_ADMIN_PASSWORD
PROD_SQL_ADMIN_PASSWORD
SONARQUBE_POSTGRES_PASSWORD
SONAR_TOKEN
```

Do not store private keys, SQL passwords, PFX files, PEM files, or `.tfvars` files in Git.

---

## 6. Terraform Operations

Terraform is divided into three environments:

```text
infra/terraform/envs/shared
infra/terraform/envs/dev
infra/terraform/envs/prod
```

### Shared

```powershell
cd infra\terraform\envs\shared
terraform init
terraform validate
terraform plan
terraform apply
```

### Dev

```powershell
cd infra\terraform\envs\dev
terraform init
terraform validate
terraform plan
terraform apply
```

### Prod

```powershell
cd infra\terraform\envs\prod
terraform init
terraform validate
terraform plan
terraform apply
```

For production, always review the plan before applying.

Expected clean state:

```text
No changes. Your infrastructure matches the configuration.
```

---

## 7. Ansible Operations

Ansible files are located in:

```text
config/ansible
```

### Dev inventory

```text
config/ansible/inventories/dev/hosts.yml
```

### Prod inventory

```text
config/ansible/inventories/prod/hosts.yml
```

### Main playbooks

```text
playbooks/site-dev.yml
playbooks/site-prod.yml
playbooks/backend.yml
playbooks/frontend.yml
```

### Local syntax check from WSL

```bash
cd /mnt/c/Users/babas/OneDrive/Documents/Projects/devops-project2-ih/config/ansible

ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/site-dev.yml --syntax-check
ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i inventories/prod/hosts.yml playbooks/site-prod.yml --syntax-check
```

---

## 8. Azure Container Registry

ACR stores Docker images for both frontend and backend.

List repositories:

```powershell
az acr repository list --name <ACR_NAME> --output table
```

Show backend tags:

```powershell
az acr repository show-tags `
  --name <ACR_NAME> `
  --repository burger-backend `
  --output table
```

Show frontend tags:

```powershell
az acr repository show-tags `
  --name <ACR_NAME> `
  --repository burger-frontend `
  --output table
```

Login to ACR:

```powershell
az acr login --name <ACR_NAME>
```

---

## 9. Key Vault Operations

### Required backend secrets

Each environment Key Vault must contain:

```text
backend-db-url
backend-db-username
backend-db-password
```

### Dev Key Vault

```text
kv-g6-burger-dev-plc
```

### Prod Key Vault

```text
kv-g6-burger-prod-plc
```

List secrets:

```bash
az keyvault secret list \
  --vault-name <KEY_VAULT_NAME> \
  --query "[].name" \
  -o table
```

Set backend password:

```bash
az keyvault secret set \
  --vault-name <KEY_VAULT_NAME> \
  --name backend-db-password \
  --value "<PASSWORD>"
```

Important:

- Backend VM reads secrets during Ansible deployment.
- Key Vault uses RBAC and network restrictions.
- App Gateway uses Key Vault certificate for HTTPS.

---

## 10. HTTPS and Certificate Operations

### Domains

```text
https://burgerapp.live
https://www.burgerapp.live
https://dev.burgerapp.live
https://sonar.burgerapp.live
```

### Certificate source

Certificates are generated using Let’s Encrypt / Certbot with DNS-01 validation.

### Certificate name in Key Vault

```text
cert-burgerapp-live
```

### Check Key Vault certificate

```bash
az keyvault certificate show \
  --vault-name <KEY_VAULT_NAME> \
  --name cert-burgerapp-live \
  --query "{name:name, enabled:attributes.enabled, expires:attributes.expires}" \
  -o table
```

### Check Application Gateway certificate

```powershell
az network application-gateway ssl-cert list `
  --resource-group <RESOURCE_GROUP> `
  --gateway-name <APPLICATION_GATEWAY_NAME> `
  --query "[].{Name:name, KeyVaultSecretId:keyVaultSecretId, ProvisioningState:provisioningState}" `
  --output table
```

Expected:

```text
ProvisioningState = Succeeded
```

---

## 11. DNS Operations

DNS is managed in Name.com.

Required A records:

| Host | Points To |
|---|---|
| @ | Production Application Gateway public IP |
| www | Production Application Gateway public IP |
| dev | Development Application Gateway public IP |
| sonar | Development Application Gateway public IP |

Validate:

```powershell
nslookup burgerapp.live
nslookup www.burgerapp.live
nslookup dev.burgerapp.live
nslookup sonar.burgerapp.live
```

---

## 12. Smoke Tests

### Production

```powershell
curl.exe -I "https://burgerapp.live"
curl.exe -I "https://www.burgerapp.live"
curl.exe -I "https://burgerapp.live/api/ingredients"
```

### Development

```powershell
curl.exe -I "https://dev.burgerapp.live"
curl.exe -I "https://dev.burgerapp.live/api/ingredients"
```

### SonarQube

```powershell
curl.exe -I "https://sonar.burgerapp.live"
```

### Backend health from VM

```bash
curl -i http://localhost:8080/actuator/health
```

Expected:

```json
{"status":"UP"}
```

---

## 13. Application Gateway Checks

### Backend health

```powershell
az network application-gateway show-backend-health `
  --resource-group <RESOURCE_GROUP> `
  --name <APPLICATION_GATEWAY_NAME> `
  --output table
```

### List listeners

```powershell
az network application-gateway http-listener list `
  --resource-group <RESOURCE_GROUP> `
  --gateway-name <APPLICATION_GATEWAY_NAME> `
  --query "[].{Name:name, Protocol:protocol, HostNames:hostNames}" `
  --output table
```

### List frontend ports

```powershell
az network application-gateway frontend-port list `
  --resource-group <RESOURCE_GROUP> `
  --gateway-name <APPLICATION_GATEWAY_NAME> `
  --output table
```

---

## 14. VM and Docker Checks

### Check VMs

```powershell
az vm list `
  --resource-group <RESOURCE_GROUP> `
  --show-details `
  --query "[].{Name:name, PowerState:powerState, Size:hardwareProfile.vmSize}" `
  --output table
```

### Check public IPs

```powershell
az vm list-ip-addresses `
  --resource-group <RESOURCE_GROUP> `
  --output table
```

Application VMs should not have public IP addresses.

### Docker check on VM

```bash
docker ps
docker compose version
```

### Backend logs

```bash
docker logs burger-backend --tail 100
```

### Frontend logs

```bash
docker logs burger-frontend --tail 50
```

---

## 15. SonarQube Operations

URL:

```text
https://sonar.burgerapp.live
```

Default initial login after reset:

```text
username: admin
password: PipPlumbers@2026
```

After login, change password immediately.

Generate token:

```text
My Account -> Security -> Generate Token
```

Recommended token:

```text
Name: github-actions-g6
Type: Global Analysis Token
Expiration: 1 year
```

Update GitHub secret:

```text
SONAR_TOKEN
```

Quality Gate recommendation:

```text
Reliability Rating is worse than C -> fail
Security Rating is worse than C -> fail
Maintainability Rating is worse than D -> fail
```

Avoid strict coverage gates for this demo unless test coverage is improved.

---

## 16. Troubleshooting

### HTTPS timeout

Check:

```powershell
az network application-gateway frontend-port list ...
az network application-gateway http-listener list ...
az network application-gateway ssl-cert list ...
az network nsg rule list ...
```

Common causes:

- 443 listener missing
- NSG does not allow 443
- Key Vault certificate access denied
- DNS points to wrong IP
- App Gateway certificate provisioning failed

### API returns empty data

Likely cause:

- Database is empty
- SQL init mode is disabled
- Seed data was not applied

Check:

```bash
curl -s http://localhost:8080/api/ingredients
```

### SQL login failed

Common cause:

- Key Vault `backend-db-password` does not match Azure SQL admin password

Ensure these match:

```text
GitHub Secret
Azure SQL admin password
Key Vault backend-db-password
terraform.tfvars value
```

### Docker permission denied on runner

Fix:

```bash
sudo usermod -aG docker azureuser

cd ~/actions-runner
sudo ./svc.sh stop
sudo ./svc.sh start
```

### SonarQube token invalid

Generate a new token from SonarQube UI and update GitHub Secret:

```text
SONAR_TOKEN
```

### Terraform drift

Run:

```powershell
terraform plan
```

If Azure Portal or CLI was used to fix something manually, reconcile the change back into Terraform code.

---

## 17. Safe Operating Rules

- Do not commit `.tfvars`, `.pfx`, `.pem`, `.key`, or private secrets.
- Do not mix infrastructure changes and application code changes in the same PR.
- Use Dev for validation before Production.
- Keep Terraform as the source of truth for infrastructure.
- Keep Key Vault secrets synchronized with application configuration.
- Use SonarQube results as part of quality validation.
- Reconcile manual Azure fixes back into Terraform.
- Rotate exposed or temporary passwords after the demo.