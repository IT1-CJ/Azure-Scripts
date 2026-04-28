# Azure Lighthouse Deployment

**Author:** Christopher Johnston  
**Organisation:** IT1 Source  

---

## Overview
Deploys Azure Lighthouse registration across all subscriptions in bulk using ARM templates.
Without this script, Lighthouse must be manually deployed to each subscription individually.

## Files

| File | Description |
|---|---|
| `deploy-lighthouse.sh` | Main deployment script — loops through all subscriptions |
| `IT1AZLHSubscription.json` | ARM template for Lighthouse subscription deployment |
| `IT1AZLHParameter.json` | Parameters — offer name, tenant ID, and role authorizations |

## Prerequisites
- Azure CLI authenticated (`az login`)
- Owner or Contributor role on all target subscriptions
- Both JSON files uploaded to Azure Cloud Shell home directory

## Usage

1. Upload `IT1AZLHSubscription.json` and `IT1AZLHParameter.json` to Azure Cloud Shell
2. Upload `deploy-lighthouse.sh` to Azure Cloud Shell
3. Make the script executable:
```bash
   chmod +x deploy-lighthouse.sh
```
4. Run the script:
```bash
   ./deploy-lighthouse.sh
```

## Roles Deployed

| Principal | Role | Description |
|---|---|---|
| Azure Lighthouse Contributors | Contributor | Full resource management |
| Azure Lighthouse Readers | Reader | Read-only access |
| Azure Lighthouse Support Contributors | Support Request Contributor | Support ticket management |

---
*IT1 Source — Internal Use Only*
