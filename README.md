## Project Overview

This project showcases the design and deployment of a resilient Azure web platform built using Infrastructure as Code principles. The solution combines networking, security, compute, monitoring, and deployment automation to provide a production-style architecture suitable for learning, demonstrations, and portfolio purposes.

## Key Components

### Networking
- Virtual Network (VNet)
- Dedicated Web Subnet
- Network Security Group (NSG)
- Public IP Addresses
- Azure Load Balancer
- Azure Application Gateway with Web Application Firewall (WAF)

### Compute
- Availability Set
- Two Windows Server 2025 Virtual Machines
- IIS Web Server

### Security
- Network Security Groups
- Restricted Administrative Access
- Azure Bastion
- Azure Key Vault
- Web Application Firewall (WAF)

### Monitoring & Operations
- Azure Monitor
- Log Analytics Workspace
- Boot Diagnostics
- Storage Account

### Automation & DevOps
- ARM Templates
- PowerShell Configuration Scripts
- Custom Script Extension
- GitHub Repository Integration
- GitHub Actions CI/CD Pipeline

---

## Solution Architecture

<img width="1867" height="943" alt="image" src="https://github.com/user-attachments/assets/6e23c40f-87f0-495d-87b8-c9e0a7aefe18" />

---

## Architecture Summary

The solution leverages a layered architecture approach:

```text
Internet
   │
   ▼
Application Gateway (WAF)
   │
   ▼
Azure Load Balancer
   │
   ▼
┌─────────────────────────────┐
│     Availability Set        │
├─────────────┬───────────────┤
│ VM-WEB-01   │ VM-WEB-02     │
│ IIS Server  │ IIS Server    │
└─────────────┴───────────────┘
   │
   ▼
Azure Monitor & Log Analytics

Supporting Services
────────────────────
• Azure Bastion
• Azure Key Vault
• Storage Account
• GitHub Actions
• ARM Templates
```

---

## Deployment

### Deploy Using Azure CLI

```bash
az deployment group create \
  --resource-group rg-web-platform \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json \
  --parameters adminPassword="<Password>"
```

---

## Post-Deployment Validation

Verify the following after deployment:

- Application Gateway is online
- Load Balancer backend pool is healthy
- Both virtual machines are running
- IIS website is accessible
- Logs are flowing into Log Analytics
- Azure Monitor is collecting metrics
- Bastion connectivity is operational
- NSG rules are applied correctly

---

## Security Controls Implemented

- Web Application Firewall (WAF)
- Restricted RDP Access
- Azure Bastion for VM Administration
- Azure Key Vault for Secret Management
- Network Security Group Protection
- Standard SKU Public IP Addresses
- Premium SSD Managed Disks
- Availability Set for High Availability

---

## Technologies Used

- Microsoft Azure
- ARM Templates
- PowerShell
- Windows Server 2025
- IIS
- Azure Monitor
- Azure Bastion
- Azure Key Vault
- Azure Application Gateway
- Azure Load Balancer
- GitHub
- GitHub Actions

---

## Author

**Matlaba Machaka**  
Azure Operations Engineer  
Johannesburg, South Africa
