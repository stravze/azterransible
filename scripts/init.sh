#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

export ARM_CLIENT_ID=$1
export ARM_CLIENT_SECRET=$2
export ARM_SUBSCRIPTION_ID=$3
export ARM_TENANT_ID=$4
export ARM_ACCESS_KEY=$5

terraform init -backend-config=backend.tfvars
    
