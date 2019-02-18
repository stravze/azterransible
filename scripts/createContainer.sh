#!/bin/bash
STORAGEACCT=$(az storage account create \
    --resource-group $1 \
    --name "rdoperftesttf$RANDOM" \
    --location uksouth \
    --sku Standard_LRS | tr -d '"')
    
echo "##vso[task.setvariable variable=terraformstorageaccount;isOutput=true]$STORAGEACCT"
