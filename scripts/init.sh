#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

terraform init -var ssh_key=$3 \
    -backend-config="storage_account_name=$1" \
    -backend-config="container_name=terraform" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="access_key=$2" 
    
