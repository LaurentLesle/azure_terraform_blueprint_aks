#!/bin/bash

# To run the deployment:
# ./deploy.sh ../step0-tfstate/terraform.tfstate [plan|apply]

# capture the current path
current_path=$(pwd)
tfstate_path=$1
tf_command=$2

cd "${tfstate_path}"
storage_account_name=$(terraform output storage_account_name)
echo ${storage_account_name}
access_key=$(terraform output access_key)
container=$(terraform output container)
tf_name="aks.tfstate"

cd "${current_path}"
pwd 

terraform init \
        -backend=true \
        -lock=false \
        -backend-config storage_account_name=${storage_account_name} \
        -backend-config container_name=${container} \
        -backend-config access_key=${access_key} \
        -backend-config key=${tf_name}

terraform ${tf_command}