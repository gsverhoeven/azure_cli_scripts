#!/bin/bash
 
# BASIC TOOLING
sudo apt update 
sudo apt install -y net-tools inxi

# XFCE & XRDP
sudo DEBIAN_FRONTEND=noninteractive apt -y install xfce4
sudo apt install -y xfce4-session
sudo apt -y install xrdp
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
sudo service xrdp restart

# FIREFOX
sudo apt install -y firefox


#sudo passwd azureuser