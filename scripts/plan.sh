#!/bin/bash
echo "TERRAFORM PLAN"
cd ../terraform 

terraform plan -var ssh_key=$1 \
  -var-file="..\terraform\backend.tfvars"
