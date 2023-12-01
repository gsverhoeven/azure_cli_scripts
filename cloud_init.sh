#!/bin/bash
#export DEBIAN_FRONTEND=noninteractive
#HOME=/home/azureuser

#sudo dpkg-reconfigure debconf --frontend=noninteractive

# BASIC TOOLING
#sudo apt-get update 
#sudo apt-get install -y net-tools inxi

# FAIL2BAN
#sudo apt-get install -y fail2ban

# XFCE & XRDP
#sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
#sudo apt-get install -y xfce4-session

#sudo apt-get -y install xrdp
# 
# # remove thinclient_drive
# sudo sed -i -e '/allow_channels=/ s/=.*/=false/' /etc/xrdp/xrdp.ini
# sudo rmdir $HOME/thinclient_drives
# 
# sudo systemctl enable xrdp
# sudo adduser xrdp ssl-cert
# echo xfce4-session >~/.xsession
# sudo service xrdp restart

# C BUILD TOOLS
#sudo apt-get -y install make
#sudo apt-get -y install g++

# FIREFOX
#sudo apt-get install -y firefox

# CMDSTAN
cd $HOME
mkdir Github # PM chown to azureuser /azureuser
cd Github
mkdir stan-dev # PM chown to azureuser /azureuser
cd stan-dev
git clone https://github.com/stan-dev/cmdstan.git --recursive
cd cmdstan/
make build # PM test this on VM, check why it errors out
make examples/bernoulli/bernoulli

# TEST STAN
#examples/bernoulli/bernoulli sample data file=examples/bernoulli/bernoulli.data.json

# # R https://cran.r-project.org/bin/linux/ubuntu/
# sudo apt-get install -y --no-install-recommends software-properties-common dirmngr
# wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
# sudo apt-get install -y --no-install-recommends r-base

# # TIDYVERSE
# sudo apt-get -y install libssl-dev libcurl4-openssl-dev unixodbc-dev \
# libxml2-dev libmariadb-dev libfontconfig1-dev libharfbuzz-dev \
# libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

#Rscript -e 'install.packages("tidyverse"); install.packages("gapminder")'

# RSTAN
#Rscript -e 'remotes::install_github(standev/cmdstanr); cmdstanr::install_stan()'

# RSTUDIO
# cd $HOME
# mkdir Downloads # PM chown to azureuser /azureuser
# cd Downloads
# RSTUDIO_FILE=rstudio-2023.09.1-494-amd64.deb
# wget -q https://download1.rstudio.org/electron/focal/amd64/$RSTUDIO_FILE
# sudo apt-get -y install gdebi-core 
# sudo gdebi -n $RSTUDIO_FILE

# CLONE RSTAN scripts from github
# PM how to authenticate

# set debconf back to default
# sudo dpkg-reconfigure debconf --frontend=dialog

# # upgrade packages
# sudo apt-get upgrade -y
# 
# # RESTART SYSTEM
# sudo reboot
