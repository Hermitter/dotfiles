#!/usr/bin/env bash

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
cockpit-machines \
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