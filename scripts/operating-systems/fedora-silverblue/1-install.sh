#!/usr/bin/env bash
DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# TODO: have the setup script move it for you
if [[ -d "$HOME/.dotfiles" ]]
then
    echo "Please move/rename this directory ~/.dotfiles"
    exit 1
fi

# Increase DNF speeds
sudo bash -c "echo -e '[main]\nmax_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

rpm-ostree upgrade

# Get config files
cp -r $DOTFILES/config/* $HOME/.config

# Get personal scripts
BIN=$HOME/.bin
cp -r $DOTFILES/bin/ $BIN

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
zsh fish exa bat starship \
wl-clipboard \
bpytop \
openssl

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
md.obsidian.Obsidian \
org.gnome.Cheese \
org.gnome.Boxes \
com.github.tchx84.Flatseal \
ch.protonmail.protonmail-bridge

# Remove unused default apps
flatpak remove -y \
org.gnome.Screenshot

# Allow user to use Wireshark
# TODO: fix group not being added
# GROUP=wireshark
# sudo bash -c "grep -E '^$GROUP:' /usr/lib/group >> /etc/group"
# sudo usermod -aG $GROUP $USER

# Generate ssh keys
ssh-keygen

# Create config files
touch $HOME/.profile
touch $HOME/.secrets

#############################################
# THEME
#############################################

# Download adw-gtk3 theme
# https://github.com/lassekongo83/adw-gtk3/releases/latest/
mkdir -p ~/.themes
TMP_DIR=$(mktemp -d)
ADW_TAR="adw-gtk3v1-8.tar.xz"
wget -P $TMP_DIR "https://github.com/lassekongo83/adw-gtk3/releases/download/v1.8/$ADW_TAR"
tar -C ~/.themes -xvf $TMP_DIR/$ADW_TAR adw-gtk3 adw-gtk3-dark

# Flatpak isn't perfect at detecting our theme so we're exposing our local themes
# and then forcing a theme for gtk3 flatpak apps.
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME=adw-gtk3-dark

# Install GTK theme and flatpak theme
flatpak install flathub -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

# Install Fonts
rpm-ostree install fira-code-fonts roboto-fontface-fonts

# Install GNOME extentions
rpm-ostree install gnome-shell-extension-appindicator

#############################################
# MISC
#############################################

# git configs
git config pull.rebase false --global
git config --global init.defaultBranch main

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
# apz.gtk.kinetic_scroll.enabled = false
# gfx.webrender.all
# layers.acceleration.force-enabled
# git config --global user.name "Hermitter"
# git config --global user.email "hermitter@jellyapple.com"