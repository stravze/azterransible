#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

terraform init \
    -backend-config="storage_account_name=$1" \
    -backend-config="container_name=terraform" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="access_key=$2" \
    -backend-config="ssh_key=$3"
    
