#!/bin/bash
#az login

# create shell variables
resourceGroup=myRGtest
location=westeurope
vnetName=TEST-VNet
subnetName=TEST-Subnet
vnetAddressPrefix=10.0.0.0/16
subnetAddressPrefix=10.0.0.0/24
vmName=TEST-VM1
vmImage=Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest
AdminUsername=azureuser
publicIP=TEST-public-ip
mypublicdns=testvm

echo "creating resource group .." $resourceGroup
echo "in location .." $location
az group create --name $resourceGroup --location $location
#echo "show resource group:"
#az group show --resource-group $resourceGroup

echo "creating virtual network .."
az network vnet create \
  --name $vnetName \
  --resource-group $resourceGroup \
  --address-prefixes $vnetAddressPrefix \
  --subnet-name $subnetName \
  --subnet-prefixes $subnetAddressPrefix

echo "creating public IP address .."
az network public-ip create \
    --resource-group $resourceGroup \
    --name $publicIP \
    --dns-name $mypublicdns

echo "creating VM .."
az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --vnet-name $vnetName \
  --subnet $subnetName \
  --image $vmImage \
  --admin-username $AdminUsername \
  --generate-ssh-keys \
  --public-ip-sku Standard

echo "show all created resources within group .."
az resource list --resource-group myRGtest --output table

# # tear it down
# echo "deleting virtual network .."
# az network vnet delete \
#   --name $vnetName \
#   --resource-group $resourceGroup
# 
# 
echo "deleting resource group .." $resourceGroup
az group delete --name $resourceGroup --yes
