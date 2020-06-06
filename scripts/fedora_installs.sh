## Right now this is more of a checklist than an actual script

# first time update
sudo dnf update -y 

# enable rpm fusion's free&non-free repos
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# install essentials
sudo dnf install -y fira-code-fonts lutris gnome-tweaks zsh toolbox tilix go ffmpeg steam SDL2-devel ssl-devel openocd ncurses-compat-libs glib glib-devel gtk-devel
sudo groupinstall -y "Development Tools"
sudo dnf install -y texlive-scheme-full

# change shell to zsh
chsh -s /bin/zsh

# download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# download fish-like plugins
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install themes
sudo dnf install -y flat-remix-icon-theme materia-gtk-theme gnome-shell-extension-material-shell roboto-fontface-fonts

# increase number of file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
