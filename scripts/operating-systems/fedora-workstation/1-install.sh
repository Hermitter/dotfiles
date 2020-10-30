#!/usr/bin/env bash
sudo dnf update -y 
DOTFILES=../../..

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Get config files
cp $DOTFILES/zsh/zshrc $HOME/.zshrc
cp -r $DOTFILES/config/ $HOME/.config

# Get personal scripts
cp -r $DOTFILES/bin/ $HOME/.bin

# Get wallpapers
cp $DOTFILES/images/Wallpapers $HOME/Pictures/Wallpapers

# Enable rpm fusion's free&non-free repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install essentials/dependencies
sudo dnf install -y zsh fish toolbox go ffmpeg SDL2-devel \
openssl-devel openocd ncurses-compat-libs glib glib-devel gtk3-devel \
java-latest-openjdk-devel \
minicom openocd \
bat exa bashtop starship

sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y texlive-scheme-full

# Install apps
sudo dnf install -y \
geary \
lutris \
gnome-tweaks \
tilix \
steam \
wireshark \
pavucontrol \
transmission-gtk \
clamtk \
pulseeffects

# Update virus database for ClamAV antivirus
sudo freshclam

# Set up Wireshark
sudo usermod -a -G wireshark $USER
sudo chmod +x /usr/bin/dumpcap # permissions fix

# Qt dark theme fix (mainly wireshark)
sudo dnf install -y qt5-qtstyleplugins
echo -e "\n# qt dark theme fix\nexport QT_QPA_PLATFORMTHEME=gtk2" >> $HOME/.profile

# Flutter
# git clone git@github.com:flutter/flutter.git -b stable --depth 1 $HOME/Documents/flutter
# $HOME/Documents/flutter/bin/flutter # set up sdk
# $HOME/Documents/flutter/bin/flutter config --no-analytics
# echo -e "\n# Flutter\nexport PATH=\"\$PATH:\$HOME/Documents/flutter/bin\"" >> $HOME/.profile

# Generate ssh keys
ssh-keygen

#############################################
# SHELL
#############################################

# Create config files
touch $HOME/.profile
touch $HOME/.secrets

# Change shell to zsh
chsh -s /bin/zsh

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download zsh fish-like plugins
git clone git://github.com/hermitter/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/hermitter/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/hermitter/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#############################################
# THEME
#############################################

# Install GTK Themes
sudo dnf install -y flat-remix-icon-theme materia-gtk-theme gnome-shell-extension-material-shell 

# Install Fonts
sudo dnf install -y fira-code-fonts roboto-fontface-fonts

# Install GNOME extentions
sudo dnf install -y gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator.noarch gnome-shell-extension-user-theme

# Change theme settings
gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark-compact"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"

#############################################
# MISC
#############################################
# git configs
git config pull.ff only

# Increase number of file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

#############################################
# WRAPPING UP
#############################################

# Warn user to reboot
echo -e '\nFINISHED INSTALLING: 1-install.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'

# Start zsh session
exec zsh -l
