#!/bin/bash
#az login

az config set core.display_region_identified=false

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
mypublicdns=gsverhoeven
NetworkSecurityGroup=myNSG
NICName=myNic
storagetype=StandardSSD_LRS
vmSize=Standard_DS1_v2
vmSizealt=Standard_D2s_v3 #(2 vcpus, 8 GiB memory)

# # tear it down
echo "deleting resource group .." $resourceGroup
az group delete --name $resourceGroup --yes

echo "remaining Azure resources in use .."
az resource list --output table