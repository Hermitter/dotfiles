#!/usr/bin/env bash
##################################################
########## Example to verify signature ##########
# # deb keys (https://www.debian.org/CD/verify)
# $ gpg --keyserver keyring.debian.org --recv-keys 6294BE9B
# $ gpg --verify-files SHA512SUMS.sign
# $ sha256sum -c *CHECKSUM

DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

sudo apt update -y
sudo apt upgrade -y 

# Install essentials/dependencies
sudo apt install -y \
cockpit \
curl \
zsh \
git \
bpytop \
exa \
bat \
trash-cli \

# Add config files
mkdir -p ~/.config
cp $DOTFILES/config/starship.toml ~/.config

# Add folder for user bins
mkdir -p ~/.bin

# Add bat symlink for batcat
ln -s /usr/bin/batcat ~/.bin/bat