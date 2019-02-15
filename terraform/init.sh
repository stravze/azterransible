#!/bin/bash
echo "************* execute terraform init"
## execute terrafotm build and sendout to packer-build-output
export ARM-CLIENT-ID=$1
export ARM-CLIENT-SECRET=$2
export ARM-SUBSCRIPTION-ID=$3
export ARM-TENANT-ID=$4
export storagekey=$5
echo "Run"
terraform init  -backend-config=backend.tfvars