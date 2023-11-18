#!/bin/bash

rm jammy-server-cloudimg-amd64.img
#wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
#cp jammy-server-cloudimg-amd64.img jammy-server-cloudimg-amd64.img.fresh
cp jammy-server-cloudimg-amd64.img.fresh jammy-server-cloudimg-amd64.img
qemu-img info jammy-server-cloudimg-amd64.img 
# 2.2 GB
qemu-img resize jammy-server-cloudimg-amd64.img 30G

cp ../cloud_init_cfg.yaml user-data

# serve user data
gnome-terminal -- python3 -m http.server --directory .

qemu-system-x86_64                                            \
    -net nic                                                    \
    -net user                                                   \
    -machine accel=kvm:tcg                                      \
    -cpu host                                                   \
    -m 512                                                      \
    -nographic                                                  \
    -hda jammy-server-cloudimg-amd64.img                        \
    -smbios type=1,serial=ds='nocloud;s=http://10.0.2.2:8000/'
