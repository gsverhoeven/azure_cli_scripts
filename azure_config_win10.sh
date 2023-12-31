# create shell variables 
export resourceGroup=win10test
export location=westeurope
export vnetName=TEST-VNet
export subnetName=TEST-Subnet
export vnetAddressPrefix=10.0.0.0/16
export subnetAddressPrefix=10.0.0.0/24
export vmName=win10test_vm1
export vmImage=MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:19045.3570.231001
export AdminUsername=azureuser
export publicIP=TEST-public-ip
export mypublicdns=gsverhoeven
export NetworkSecurityGroup=myNSG
export NICName=myNic
export storagetype=StandardSSD_LRS
#export vmSize=Standard_DS1_v2 # (1 vcpu, 3.5 gb mem, cloudinit takes 2 h)
export vmSize=Standard_D2s_v3 #(2 vcpus, 8 GiB memory)
#export vmSize=Standard_D8_v3 # 8CPU 32GB (cloudninit takes 30 min)
