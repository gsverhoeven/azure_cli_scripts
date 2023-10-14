#!/bin/bash
 
sudo apt install net-tools
sudo apt-get update 
sudo apt install -y inxi
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
sudo apt install -y xfce4-session

sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
sudo service xrdp restart

#sudo passwd azureuser

sudo apt install -y firefox
