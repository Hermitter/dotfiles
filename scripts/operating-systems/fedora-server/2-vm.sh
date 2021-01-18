#!/usr/bin/env bash

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
qemu-kvm \
libvirt \
libguestfs-tools \
virt-install \
rsync \
vagrant \
vagrant-sshfs \
vagrant-libvirt


#############################################
# Configs
#############################################
sudo systemctl enable --now libvirtd