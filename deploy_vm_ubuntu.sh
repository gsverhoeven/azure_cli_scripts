#!/bin/bash
#az login

az config set core.collect_telemetry=no
az config set core.display_region_identified=false

source ./azure_config_ubuntu.sh

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
    --name $NetworkSecurityGroup \
    --output $azOutput

echo "create SSH rule .."
az network nsg rule create \
    --resource-group $resourceGroup \
    --nsg-name $NetworkSecurityGroup \
    --name myNetworkSecurityGroupRuleSSH \
    --description "Allow SSH at port 22" \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 22 \
    --access allow \
    --output $azOutput

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
    --access allow \
    --output $azOutput \
    --source-address-prefixes $trustedIPAdress

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
  --generate-ssh-keys \
  --output $azOutput \
  --security-type Standard # no trusted launch

echo "show all created resources within group .."
az resource list --resource-group $resourceGroup \
  --output table

echo "fetching public ssh keys from VM.."
ssh-keyscan -H $mypublicdns.westeurope.cloudapp.azure.com >> ~/.ssh/known_hosts

echo "fetching cloud-init output.."
scp $AdminUsername@$mypublicdns.$location.cloudapp.azure.com:/var/log/cloud-init-output.log .

echo "to connect to VM:"
echo "ssh $AdminUsername@$mypublicdns.$location.cloudapp.azure.com"

echo "to check on status cloud-init:"
echo "cat /var/log/cloud-init-output.log"


#sudo passwd azureuser # PM set this to pwd from keepass, figure out a secure way, needed for RDP access