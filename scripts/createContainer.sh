#!/bin/bash
STORAGEACCT=$(az storage account create \
    --resource-group $terraformstoragerg \
    --name "rdoperftesttf$RANDOM" \
    --location uksouth \
    --sku Standard_LRS \
    --query "name" | tr -d '"')
    
echo "##vso[task.setvariable variable=terraformstorageaccount;isOutput=true]$STORAGEACCT"
