#############################################
# INSTALLATION (NOT AUTOMATED)
#############################################
# Download RPM and GPG signature https://mullvad.net/en/download/#linux
# rpm --checksig MullvadVPN-XXXX_x86_64.rpm
# sudo dnf -y install ./MullvadVPN-XXXX_x86_64.rpm

#############################################
# ACCOUNT/CONFIG SETUP
#############################################
read -p "Enter Mullvad Account Token: " MULLVAD_TOKEN
mullvad account set $MULLVAD_TOKEN
mullvad lan set allow
mullvad auto-connect set on
mullvad always-require-vpn set on
mullvad connect
mullvad status
