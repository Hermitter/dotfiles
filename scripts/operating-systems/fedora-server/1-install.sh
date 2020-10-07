#!/usr/bin/env bash
sudo dnf update -y 
DOTFILES=../../..

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################

# Install essentials/dependencies
sudo dnf install -y \
podman \
zsh \
toolbox \
bat \
exa \
bashtop \
jq

#############################################
# SHELL
#############################################
# Get config
cp $DOTFILES/zsh/*zshrc $HOME/.zshrc

# Change shell to zsh
chsh -s /bin/zsh

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download zsh fish-like plugins
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create config files
touch $HOME/.profile
touch $HOME/.secrets