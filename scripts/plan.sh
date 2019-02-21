#!/bin/bash
echo "TERRAFORM PLAN"
cd ../terraform 

terraform plan -var ssh_key=$3 \
  -var-file="..\terraform\backend.tfvars"
