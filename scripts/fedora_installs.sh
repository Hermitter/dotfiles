## Right now this is more of a checklist than an actual script

# first time update
sudo dnf update -y 

# not sure what this is for
#sudo dnf groupupdate Multimedia

# enable rpm fusion's free&non-free repos
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# install essentials
sudo dnf install -y fira-code-fonts lutris gnome-tweaks zsh toolbox tilix go ffmpeg steam
sudo dnf install -y texlive-scheme-full
sudo groupinstall -y "Development Tools"

# change shell to zsh
chsh -s /bin/zsh

# download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# download fish-like plugins
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# themes
sudo dnf install deepin-icon-theme
sudo dnf install -y materia-gtk-theme
sudo dnf install gnome-shell-extension-material-shell
sudo dnf install roboto-fontface-fonts
flatpak install org.gtk.Gtk3theme.Materia