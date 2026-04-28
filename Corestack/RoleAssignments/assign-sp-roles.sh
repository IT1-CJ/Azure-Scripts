#!/bin/bash
# =============================================================
# Azure SP Role Assignment Script
# Author:       Christopher Johnston
# Organisation: IT1 Source
# Contact:      christopher.johnston@it1.com
# Description:  Assigns Reader (all subscriptions) + 
#               Reservations Reader and Savings Plan Reader 
#               (tenant-wide) to a Service Principal
# =============================================================

SP_OBJECT_ID="<your-service-principal-object-id>"

echo "========================================"
echo " IT1 Source - Azure SP Role Assignment"
echo "========================================"

# --- Reader: All Subscriptions ---
echo ""
echo "[1/3] Assigning Reader to all subscriptions..."
subscriptions=$(az account list --query "[].id" -o tsv)

for sub_id in $subscriptions; do
    echo "  -> Subscription: $sub_id"
    az role assignment create \
        --assignee "$SP_OBJECT_ID" \
        --role "Reader" \
        --scope "/subscriptions/$sub_id" \
        --output none
done
echo "  Reader assignment complete."

# --- Reservations Reader: Tenant-wide ---
echo ""
echo "[2/3] Assigning Reservations Reader (tenant-wide)..."
az role assignment create \
    --assignee "$SP_OBJECT_ID" \
    --role "Reservations Reader" \
    --scope "/providers/Microsoft.Capacity" \
    --output none
echo "  Reservations Reader assignment complete."

# --- Savings Plan Reader: Tenant-wide ---
echo ""
echo "[3/3] Assigning Savings Plan Reader (tenant-wide)..."
az role assignment create \
    --assignee "$SP_OBJECT_ID" \
    --role "Savings plan reader" \
    --scope "/providers/Microsoft.BillingBenefits" \
    --output none
echo "  Savings Plan Reader assignment complete."

echo ""
echo "========================================"
echo " All role assignments complete!"
echo "========================================"
