# Ansible Configuration

This directory contains Ansible inventories, playbooks, and roles used to configure and deploy the VM-based application environments.

## Environments

- inventories/dev: Dev environment hosts and variables
- inventories/prod: Prod environment hosts and variables

## Main Playbooks

- playbooks/ping.yml: SSH connectivity test
- playbooks/site-dev.yml: Full Dev server configuration
- playbooks/site-prod.yml: Full Prod server configuration
- playbooks/frontend.yml: Frontend deployment
- playbooks/backend.yml: Backend deployment
- playbooks/sonarqube.yml: Dev-only SonarQube deployment

## Execution model

Ansible is executed from the corresponding self-hosted runner VM:

- Dev runner uses inventories/dev/hosts.ini
- Prod runner uses inventories/prod/hosts.ini

VMs do not have public IP addresses. SSH access is private within each VNet.
