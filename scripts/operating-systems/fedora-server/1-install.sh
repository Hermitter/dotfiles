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
git \
podman \
zsh \
toolbox \
bat \
exa \
bashtop \
jq

# Generate ssh keys
ssh-keygen

#############################################
# SHELL
#############################################

# Get config
cp $DOTFILES/zsh/zshrc $HOME/.zshrc

# Change shell to zsh
chsh -s /bin/zsh

# Download oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download zsh fish-like plugins
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Get config files
cp $DOTFILES/zsh/zshrc $HOME/.zshrc

# Create config files
touch $HOME/.profile
touch $HOME/.secrets