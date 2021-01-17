#!/usr/bin/env bash
sudo dnf update -y 
DOTFILES=../../..

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Get personal scripts
cp -r $DOTFILES/bin/ $HOME/.bin

# Install essentials/dependencies
sudo dnf install -y \
starship \
git \
podman \
podman-compose \
cockpit-podman \
cockpit-machines \
zsh \
toolbox \
bat \
exa \
bashtop \
jq \
trash-cli

# Generate ssh keys
ssh-keygen

#############################################
# SHELL
#############################################

# Change shell to zsh
chsh -s /bin/zsh

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download zsh fish-like plugins
git clone git://github.com/hermitter/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/hermitter/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/hermitter/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Get config
cp $DOTFILES/zsh/zshrc $HOME/.zshrc

# Create config files
touch $HOME/.profile
touch $HOME/.secrets

# Start zsh session
echo -e '\nFINISHED INSTALLING: 1-install.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'
exec zsh -l