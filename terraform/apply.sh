#!/bin/bash
echo "************* execute terraform apply"
## execute terrafotm build and sendout to packer-build-output
export ARM-CLIENT-ID=$1
export ARM-CLIENT-SECRET=$2
export ARM-SUBSCRIPTION-ID=$3
export ARM-TENANT-ID=$4
export storagekey=$5
export SSH_PUB_KEY=$6

terraform apply -auto-approve -var ssh_key=$6 

export vm_name=$(terraform outputperf_test_vm_name)
echo "host1 ansible_ssh_port=50001 ansible_ssh_host=$vm_name" > inventory
echo "host2 ansible_ssh_port=50002 ansible_ssh_host=$vm_name" >> inventory

cat inventory