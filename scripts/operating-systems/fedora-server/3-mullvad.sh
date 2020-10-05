#############################################
# INSTALLATION 
#############################################
wget --content-disposition https://mullvad.net/download/rpm/latest
sudo dnf -y install ./MullvadVPN-*

# Remember to download the signature and check the package: (https://mullvad.net/en/download/#linux)
# $ rpm --checksig MullvadVPN-XXXX_x86_64.rpm

#############################################
# CONFIG 
#############################################
read -p "Enter Mullvad Account Token: " MULLVAD_TOKEN
mullvad account set $MULLVAD_TOKEN
mullvad lan set allow
mullvad auto-connect set on
mullvad always-require-vpn set on
mullvad connect
mullvad status