#!/usr/bin/env bash
DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# Increase DNF speeds
sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

rpm-ostree upgrade

# Get config files
cp -r $DOTFILES/config/* $HOME/.config

# Get personal scripts
BIN=$HOME/.bin
cp -r $DOTFILES/bin/ $BIN
curl -L https://github.com/Hermitter/tepe/releases/latest/download/tepe-x86_64-unknown-linux-musl -o $BIN/tepe && chmod +x $BIN/tepe

# Get wallpapers
cp -r $DOTFILES/images/Wallpapers $HOME/Pictures/Wallpapers

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Enable rpm fusion's free&non-free repos
rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install essentials
rpm-ostree install \
tilix \
podman-compose \
util-linux-user \
zsh fish exa bat starship \
wl-clipboard \
bpytop \
cheese

# Install Fedora Flatpak apps
flatpak install fedora -y \
org.gnome.FileRoller \
org.gnome.Geary \
org.gnome.Extensions \
com.transmissionbt.Transmission

# Install Flathub Flatpak apps
flatpak install flathub -y \
org.gnome.Totem \
org.wireshark.Wireshark \
org.pulseaudio.pavucontrol \
com.valvesoftware.Steam \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.discordapp.Discord \
com.slack.Slack \
org.gabmus.hydrapaper \
com.dropbox.Client \
md.obsidian.Obsidian

# Generate ssh keys
ssh-keygen

# Create config files
touch $HOME/.profile
touch $HOME/.secrets

#############################################
# THEME
#############################################

# Install GTK theme and flatpak theme
rpm-ostree install flat-remix-icon-theme materia-gtk-theme
flatpak install -y flathub org.gtk.Gtk3theme.Materia{,-dark,-light}{,-compact}

# Install Fonts
rpm-ostree install fira-code-fonts roboto-fontface-fonts

# Install GNOME extentions
rpm-ostree install gnome-shell-extension-appindicator

#############################################
# MISC
#############################################

# git configs
git config pull.rebase false --global

# Increase number of file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

#############################################
# WRAPPING UP
#############################################

echo -e '\nFINISHED INSTALLING: 1-install.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'

#############################################
# UNUSED AREA
#############################################
# Firefox (about:config) I don't know how to automate this >:(
# gfx.webrender.all
# layers.acceleration.force-enabled