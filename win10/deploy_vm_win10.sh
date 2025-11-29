#!/bin/bash
#az login

az config set core.collect_telemetry=no
az config set core.display_region_identified=false

source ./azure_config_win10.sh

echo "creating resource group .." $resourceGroup
echo "in location .." $location

az group create \
  --name $resourceGroup \
  --location $location \
  --output $azOutput

echo "creating virtual network .."
az network vnet create \
  --name $vnetName \
  --resource-group $resourceGroup \
  --address-prefixes $vnetAddressPrefix \
  --subnet-name $subnetName \
  --subnet-prefixes $subnetAddressPrefix \
  --output $azOutput

echo "creating public IP address .."
az network public-ip create \
    --resource-group $resourceGroup \
    --name $publicIP \
    --sku standard \
    --dns-name $mypublicdns \
    --output $azOutput \
    --zone 1 # non-zonal IP

echo "list all ip adresses .."
az network public-ip list -o table

echo "creating Network Security Group .."
az network nsg create \
    --resource-group $resourceGroup \
    --output $azOutput \
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
    --output $azOutput \
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
    --output $azOutput \
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
    --output $azOutput \
    --network-security-group $NetworkSecurityGroup

echo "allow Standard security.."

az feature register --name UseStandardSecurityType --namespace Microsoft.Compute
az feature show --name UseStandardSecurityType --namespace Microsoft.Compute

echo "creating VM .."
az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --nics $NICName \
  --image $vmImage \
  --storage-sku $storagetype \
  --size $vmSize \
  --admin-username $AdminUsername \
  --generate-ssh-keys \
  --output $azOutput \
  --security-type Standard # no trusted launch

#  --admin-username azureuser
#  --admin-password $mysecretpwd
#  --custom-data $customDataScript \

echo "show all created resources within group .."
az resource list --resource-group $resourceGroup \
  --output table

echo "to connect to VM:"
echo "ssh azureuser@gsverhoeven.westeurope.cloudapp.azure.com"

#echo "then set pwd on azureuser"

echo "to remove the complete resource group including VM" 
echo "az group delete --name win10test --yes"

#sudo passwd azureuser # PM set this to pwd from keepass, figure out a secure way, needed for RDP access
