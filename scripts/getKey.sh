#!/bin/bash
key=$(az storage account keys list \
    --resource-group $terraformstoragerg \
    --account-name $terraformstorageaccount \
    --query "[0].value" | tr -d '"')

echo "##vso[task.setvariable variable=storagekey;isOutput=true]$key"
