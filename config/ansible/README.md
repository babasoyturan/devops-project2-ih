# Ansible Configuration

This directory contains Ansible inventories, playbooks, and roles used to configure and deploy the VM-based Azure application environments.

## Structure

- inventories/dev: Dev hosts and variables
- inventories/prod: Prod hosts and variables
- oles/common: Base Linux configuration
- oles/docker: Docker Engine and Docker Compose plugin installation
- oles/sonarqube: Dev-only SonarQube deployment
- oles/frontend: Frontend container deployment
- oles/backend: Backend container deployment

## Execution model

Ansible is intended to run from GitHub Actions on environment-specific self-hosted runners.

- Dev Ansible jobs run on the Dev runner.
- Prod Ansible jobs run on the Prod runner.
- Target VMs do not have public IP addresses.
- SSH connectivity is private inside each VNet.

## Main playbooks

- playbooks/ping.yml: SSH connectivity test
- playbooks/common.yml: Common Linux setup
- playbooks/docker.yml: Docker setup
- playbooks/sonarqube.yml: SonarQube setup for Dev
- playbooks/frontend.yml: Frontend deployment
- playbooks/backend.yml: Backend deployment
- playbooks/site-dev.yml: Full Dev configuration
- playbooks/site-prod.yml: Full Prod configuration

## Required runtime secrets

These values should be passed from GitHub Actions secrets or environment variables:

- ANSIBLE_SSH_PRIVATE_KEY
- ACR_USERNAME
- ACR_PASSWORD
- BACKEND_DB_USERNAME
- BACKEND_DB_PASSWORD
- SONARQUBE_POSTGRES_PASSWORD

Do not commit private keys, .env files, database passwords, or ACR credentials.
