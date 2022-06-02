#!/usr/bin/env bash

# Allow user to access serial ports
GROUP=dialout
sudo bash -c "grep -E '^$GROUP:' /usr/lib/group >> /etc/group"
sudo usermod -aG $GROUP $USER

# Install Adruino IDE
flatpak install -y flathub cc.arduino.arduinoide

# Reboot to load group changes to user
echo -e '\nFINISHED INSTALLING: 6-arduino.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'
