#!/bin/bash
key=$(az storage account keys list \
    --resource-group $1 \
    --account-name $2 \
    --query "[0].value" | tr -d '"')

echo "##vso[task.setvariable variable=storagekey;isOutput=true]$key"
