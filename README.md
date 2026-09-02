# Azure ARM IIS Web Farm

Infrastructure as Code project deploying a highly available IIS environment in Microsoft Azure.

## Resources Deployed

- Virtual Network
- Subnet
- Network Security Group
- Availability Set
- 2 Windows Server 2025 Virtual Machines
- 2 Public IP Addresses
- 2 Network Interfaces
- Storage Account
- IIS Installation using Custom Script Extension

## Architecture

![ages/architecture.png

## Deployment

### Azure CLI

```bash
az deployment group create \
--resource-group rg-iis-demo \
--template-file azuredeploy.json \
--parameters @azuredeploy.parameters.json \
--parameters adminPassword="<Password>"
```

## Access

### HTTP

```text
http://<public-ip>
```

### RDP

```text
mstsc
```

Connect using:

```text
Username: azureadmin
Password: <deployment password>
```
## Diagram

<img width="1848" height="920" alt="Screenshot 2026-09-02 122407" src="https://github.com/user-attachments/assets/5af71b2b-71cd-40f6-80f9-30e4268a8e43" />

## Security Features

- Standard SKU Public IPs
- Restricted RDP Access
- Availability Set
- Premium SSD OS Disks
- Network Security Group

## Author

Matlaba Machaka

Azure Operations Engineer
