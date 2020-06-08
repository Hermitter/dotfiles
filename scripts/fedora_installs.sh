sudo dnf update -y 

#############################################
# APPLICATIONS
#############################################

# Enable rpm fusion's free&non-free repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install essentials
sudo dnf install -y lutris gnome-tweaks zsh toolbox tilix go ffmpeg steam SDL2-devel ssl-devel openocd ncurses-compat-libs glib glib-devel gtk-devel wireshark
sudo groupinstall -y "Development Tools"
sudo dnf install -y texlive-scheme-full

# Set up Wireshark
sudo usermod -a -G wireshark $USER
sudo chmod +x /usr/bin/dumpcap # permissions fix

# Qt dark theme fix (mainly wireshark)
sudo dnf install -y qt5-qtstyleplugins
echo -e "\n# qt dark theme fix\nexport QT_QPA_PLATFORMTHEME=gtk2" >> $HOME/.profile

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

# Themes
sudo dnf install -y flat-remix-icon-theme materia-gtk-theme gnome-shell-extension-material-shell 

# Fonts
sudo dnf install -y fira-code-fonts roboto-fontface-fonts

#############################################
# MISC
#############################################

# Increase number of file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p