#!/bin/bash
echo "TERRAFORM INIT"
cd ../terraform 

terraform plan -var ssh_key=$1
