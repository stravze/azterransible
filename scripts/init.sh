#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

echo $1
echo $2

# terraform init \
#     -backend-config="storage_account_name=$1" \
#     -backend-config="container_name=terraform" \
#     -backend-config="key=terraform.tfstate" \
#     -backend-config="access_key=$2"
    
