#!/bin/bash
#az login

az config set core.display_region_identified=false

source ./azure_config_win10.sh

# # tear it down
echo "deleting resource group .." $resourceGroup
az group delete --name $resourceGroup --yes

echo "remove VM from known_hosts .."
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$mypublicdns.$location.cloudapp.azure.com"

echo "remaining Azure resources in use .."
az resource list --output table
