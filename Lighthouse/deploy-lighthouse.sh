#!/bin/bash
# =============================================================
# Azure Lighthouse Deployment Script
# Author:       Christopher Johnston
# Organisation: IT1 Source
# Contact:      christopher.johnston@it1.com
# Description:  Deploys Lighthouse ARM template to all 
#               subscriptions in bulk
# =============================================================

TEMPLATE_FILE="~/IT1AZLHSubscription.json"
PARAMETER_FILE="~/IT1AZLHParameter.json"
DEPLOYMENT_NAME="IT1-Lighthouse-Deployment"
LOCATION="eastus"

echo "========================================"
echo " IT1 Source - Azure Lighthouse Deployment"
echo "========================================"

subscriptions=$(az account list --query "[].{id:id, name:name}" -o tsv)

while IFS=$'\t' read -r sub_id sub_name; do
    echo ""
    echo "-> Deploying to: $sub_name ($sub_id)"
    
    az account set --subscription "$sub_id"
    
    az deployment sub create \
        --name "$DEPLOYMENT_NAME" \
        --location "$LOCATION" \
        --template-file "$TEMPLATE_FILE" \
        --parameters "@$PARAMETER_FILE" \
        --output none
    
    if [ $? -eq 0 ]; then
        echo "   SUCCESS: $sub_name"
    else
        echo "   FAILED:  $sub_name - check permissions"
    fi

done <<< "$subscriptions"

echo ""
echo "========================================"
echo " Lighthouse deployment complete!"
echo "========================================"
