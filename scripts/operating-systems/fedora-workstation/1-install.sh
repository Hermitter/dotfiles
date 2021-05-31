#!/usr/bin/env bash
DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# Increase DNF speeds
sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

sudo dnf upgrade -y 

# Get config files
cp -r $DOTFILES/config/* $HOME/.config

# Get personal scripts
BIN=$HOME/.bin
cp -r $DOTFILES/bin/ $BIN
curl -L https://github.com/Hermitter/tepe/releases/latest/download/tepe-linux-amd64 -o $BIN/tepe && chmod +x $BIN/tepe

# Get wallpapers
cp -r $DOTFILES/images/Wallpapers $HOME/Pictures/Wallpapers

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Enable rpm fusion's free&non-free repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable offline upgrades from cli
# - download upgrade: sudo dnf offline-upgrade download
# - apply upgrade: sudo dnf offline-upgrade reboot
sudo dnf install 'dnf-command(system-upgrade)' -y

# Install essentials
sudo dnf install -y \
ascii \
toolbox \
podman-compose \
util-linux-user \
wl-clipboard xclip \
trash-cli zsh fish bat exa bpytop starship \
openssl-devel \
nghttp2 \
java-latest-openjdk-devel

sudo dnf groupinstall -y "Development Tools"

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
pulseeffects \
blueman

# Install media codecs
sudo dnf install ffmpeg -y
sudo dnf groupinstall Multimedia -y

# Install GNOME extentions
sudo dnf install -y gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator gnome-shell-extension-user-theme

# Set up Wireshark
sudo usermod -a -G wireshark $USER
sudo chmod +x /usr/bin/dumpcap # permissions fix

# Generate ssh keys
ssh-keygen

#############################################
# SHELL
#############################################

# Create config files
touch $HOME/.profile
touch $HOME/.secrets

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download zsh fish-like plugins
git clone git://github.com/hermitter/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/hermitter/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/hermitter/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Get zsh config
cp $DOTFILES/zsh/zshrc $HOME/.zshrc

#############################################
# THEME
#############################################

# Install GTK theme and Flatpak theme
sudo dnf install -y flat-remix-icon-theme materia-gtk-theme gnome-shell-extension-material-shell 
flatpak install -y flathub org.gtk.Gtk3theme.Materia{,-dark,-light}{,-compact}

# Install Fonts
sudo dnf install -y fira-code-fonts roboto-fontface-fonts

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

# Warn user to reboot
echo -e '\nFINISHED INSTALLING: 1-install.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'

# Start zsh session
exec zsh -l

# Change shell to zsh
echo "Changing shell to zsh..."
chsh -s /bin/zsh

#############################################
# UNUSED AREA
#############################################

# Install ClamAV antivirus & update datavase
# sudo dnf install -y clamtk
# sudo freshclam

# VS Code installation: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# sudo dnf check-update
# sudo dnf install -y code

# Firefox (about:config) these settings can't be automated >:(
# gfx.webrender.all
# layers.acceleration.force-enabled

# Install Wine dependancies (for windows games, apps, etc.)
# sudo dnf install wine dxvk-winelib

# unused dnf dependencies (TODO: remove after test)
# SDL2-devel
# glib glib-devel gtk3-devel
# minicom openocd
# ncurses-compat-libs
# sudo dnf install -y texlive-scheme-full

# Qt dark theme fix (mainly wireshark)
# sudo dnf install -y qt5-qtstyleplugins
# echo -e "\n# qt dark theme fix\nexport QT_QPA_PLATFORMTHEME=gtk2" >> $HOME/.profile
