#!/usr/bin/env bash
DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# Set zsh as default shell
chsh -s /bin/zsh

# Install Starship cross-shell prompt (https://starship.rs/guide/#%F0%9F%9A%80-installation)
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Install ZSH framework (https://ohmyz.sh/#install)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone git://github.com/hermitter/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/hermitter/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/hermitter/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create config files
cp $DOTFILES/zsh/zshrc $HOME/.zshrc
touch $HOME/.profile
touch $HOME/.secrets

# Start zsh session
echo -e '\nFINISHED INSTALLING: 2-shell.sh'
exec zsh -l