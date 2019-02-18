#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

terraform init \
    -backend-config="storage_account_name=$1" \
    -backend-config="container_name=$2" \
    -backend-config="key=$3/terraform.tfstate" 
    
