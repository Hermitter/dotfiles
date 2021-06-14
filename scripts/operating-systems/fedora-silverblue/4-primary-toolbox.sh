## TODO: fully test this script ##
toolbox create -y

# Increase download speeds
toolbox run sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

# Install essential apps and deps
toolbox run sudo dnf install -y \
zsh \
fish \
starship \
exa \
bat \
bpytop \
trash-cli \
wl-clipboard \
nano \
openssl-devel \
nghttp2

# Install vscode in toolbox
# Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
toolbox run sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
toolbox run sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
toolbox run sudo dnf check-update
toolbox run sudo dnf install code -y

# VScode dependency to solve inconsistent error: "error while loading shared libraries: libxshmfence.so.1"
# TODO: test if libicu is also needed
toolbox run sudo dnf install qt5-qtwayland -y

# Add a PATH variable xdg-open that points to host machine's xdg-open 
CUSTOM_XDG_OPEN=~/.bin/xdg-open
toolbox run echo '
#\!/bin/sh
if [[ -v $TOOLBOX_PATH ]] | [[ -z $TOOLBOX_PATH ]]; then
  /usr/bin/xdg-open
else
  ${TOOLBOX_PATH:+flatpak-spawn --host} /usr/bin/xdg-open "$@"
fi
' > $CUSTOM_XDG_OPEN
chmod +x $CUSTOM_XDG_OPEN

# Add a .desktop that calls into the toolbox's VScode
# TODO:  ...
