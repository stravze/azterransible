#!/bin/bash
echo "************* execute terraform init"
cd ../terraform 

terraform init \
    -backend-config= # awaiting input
