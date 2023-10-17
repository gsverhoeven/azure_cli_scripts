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
customDataScript=cloud_init.sh

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
    --sku standard \
    --dns-name $mypublicdns

echo "list all ip adresses .."
az network public-ip list -o table

echo "creating Network Security Group .."
az network nsg create \
    --resource-group $resourceGroup \
    --name $NetworkSecurityGroup

echo "create SSH rule .."
az network nsg rule create \
    --resource-group $resourceGroup \
    --nsg-name $NetworkSecurityGroup \
    --name myNetworkSecurityGroupRuleSSH \
    --description "Allow SSH at port 22" \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 22 \
    --access allow

echo "create RDP rule .."
az network nsg rule create \
    --resource-group $resourceGroup \
    --nsg-name $NetworkSecurityGroup \
    --name myNetworkSecurityGroupRuleRDP \
    --description "Allow RDP at port 3389" \
    --direction Inbound \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 3389 \
    --access allow
#--source-address-prefixes TRUSTED-IP-ADDRESS/32

echo "check NSG rules .."
az network nsg rule list \
    --resource-group $resourceGroup \
    --nsg-name $NetworkSecurityGroup \
    --output table

echo "create NIC .."

az network nic create \
    --resource-group $resourceGroup \
    --name $NICName \
    --vnet-name $vnetName \
    --subnet $subnetName \
    --public-ip-address $publicIP \
    --network-security-group $NetworkSecurityGroup

echo "creating VM .."
az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --nics $NICName \
  --image $vmImage \
  --storage-sku $storagetype \
  --size $vmSize \
  --admin-username $AdminUsername \
  --custom-data $customDataScript \
  --generate-ssh-keys

echo "show all created resources within group .."
az resource list --resource-group $resourceGroup \
  --output table
