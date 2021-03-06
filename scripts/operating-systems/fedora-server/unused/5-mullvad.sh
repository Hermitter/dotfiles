#!/usr/bin/env bash
#############################################
# INSTALLATION (NOT AUTOMATED)
#############################################

# Download RPM and GPG signature https://mullvad.net/en/download/#linux
# rpm --checksig MullvadVPN-XXXX_x86_64.rpm
# sudo dnf -y install ./MullvadVPN-XXXX_x86_64.rpm

if ! hash mullvad &> /dev/null; then
  echo "Mullvad is not installed!"
  echo -e "Get it here: https://mullvad.net/en/download/rpm/latest#linux\n"
  exit 1
fi

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


# Mention port forwarding tutorials
echo -e "Need to port forward? Here are some helpful guides:
    https://mullvad.net/en/help/port-forwarding-and-mullvad/
    https://mullvad.net/nl/help/plex-mullvad/
"

echo -e "\nMULLVAD IS NOW READY"

#############################################
# SHELL CONFIG
#############################################

# print connection status for each session
echo 'mullvad status' >> $HOME/.profile