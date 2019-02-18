#!/bin/bash

STORAGEACCT=$(az storage account create \
    --resource-group $1 \
    --name "rdoperftesttf$RANDOM" \
    --location uksouth \
    --sku Standard_LRS | tr -d '"')
    
STORAGECONT=$(az storage container create \
    --name "terraform" \
    --account-name $STORAGEACCT | tr -d '"')

STORAGEKEY=$(az storage account keys list \
    --resource-group $1 \
    --account-name $STORAGEACCT \
    --query "[0].value" | tr -d '"')
  
echo "##vso[task.setvariable variable=terraformstorageaccount;isOutput=true]$STORAGEACCT"
echo "##vso[task.setvariable variable=storagekey;isOutput=true]$STORAGEKEY"
