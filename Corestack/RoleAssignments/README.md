# Azure Role Assignments

**Author:** Christopher Johnston  
**Organisation:** IT1 Source  

---

## Overview
Assigns Azure RBAC roles to a Service Principal across all subscriptions and at tenant level.

## Files

| File | Description |
|---|---|
| `assign-sp-roles.sh` | Assigns Reader, Reservations Reader, and Savings Plan Reader to a service principal |

## Prerequisites
- Azure CLI authenticated (`az login`)
- Owner or User Access Administrator role
- Service Principal Object ID

## Usage

1. Upload `assign-sp-roles.sh` to Azure Cloud Shell
2. Make the script executable:
```bash
   chmod +x assign-sp-roles.sh
```
3. Edit the script and update the `SP_OBJECT_ID` variable at the top with your Service Principal Object ID
4. Run the script:
```bash
   ./assign-sp-roles.sh
```

## Roles Assigned

| Role | Scope | Purpose |
|---|---|---|
| Reader | All subscriptions | Read access to all Azure resources |
| Reservations Reader | Tenant-wide | Read access to Azure Reservations |
| Savings Plan Reader | Tenant-wide | Read access to Azure Savings Plans |

---
*IT1 Source — Internal Use Only*
