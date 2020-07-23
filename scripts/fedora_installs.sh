sudo dnf update -y 

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Enable rpm fusion's free&non-free repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install essentials/dependencies
sudo dnf install -y zsh toolbox go ffmpeg SDL2-devel \
openssl-devel openocd ncurses-compat-libs glib glib-devel gtk3-devel \
java-latest-openjdk-devel java-1.8.0-openjdk-devel \
arm-none-eabi-gdb minicom openocd

sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y texlive-scheme-full

# Install apps
sudo dnf install -y geary lutris gnome-tweaks tilix steam wireshark

# Set up Wireshark
sudo usermod -a -G wireshark $USER
sudo chmod +x /usr/bin/dumpcap # permissions fix

# Geary dark theme fix for header
echo -e "hr {\n\tcolor: #eeeeec \!important;\n\tbackground-color: #eeeeec \!important;\n}" >> $HOME/.config/geary/user-style.css

# Qt dark theme fix (mainly wireshark)
sudo dnf install -y qt5-qtstyleplugins
echo -e "\n# qt dark theme fix\nexport QT_QPA_PLATFORMTHEME=gtk2" >> $HOME/.profile

# Flutter
git clone git@github.com:flutter/flutter.git -b stable --depth 1 $HOME/Documents/flutter
$HOME/Documents/flutter/bin/flutter # set up sdk
$HOME/Documents/flutter/bin/flutter config --no-analytics
echo -e "\n# Flutter\nexport PATH=\"\$PATH:\$HOME/Documents/flutter/bin\"" >> $HOME/.profile

#############################################
# SHELL
#############################################

# Change shell to zsh
chsh -s /bin/zsh

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download zsh fish-like plugins
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

# Increase number of file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
