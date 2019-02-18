storagekey=$(az storage account keys list \
    --resource-group $(terraformstoragerg) \
    --account-name $(terraformstorageaccount) \
    --query "[0].value" | tr -d '"')
