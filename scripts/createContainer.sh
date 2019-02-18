#!/bin/bash
echo my variable is 1 $terraformstoragerg
echo my variable is 2 $(terraformstoragerg)
echo *******************
STORAGEACCT=$(az storage account create \
    --resource-group $(terraformstoragerg) \
    --name "rdoperftesttf$RANDOM" \
    --location uksouth \
    --sku Standard_LRS | tr -d '"')
    
echo "##vso[task.setvariable variable=terraformstorageaccount;isOutput=true]$STORAGEACCT"
