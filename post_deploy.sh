#!/bin/bash
 
# BASIC TOOLING
sudo apt-get update 
sudo apt-get install -y net-tools inxi

# XFCE & XRDP
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
sudo apt-get install -y xfce4-session
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
sudo service xrdp restart

# FIREFOX
sudo apt-get install -y firefox


#sudo passwd azureuser