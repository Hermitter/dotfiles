#!/usr/bin/env bash

# Install media codecs
# TODO: find more: gstreamer1-plugin-openh264
rpm-ostree install ffmpeg

# Unsure if needed in flatpak version
# # Set up Wireshark
# sudo usermod -a -G wireshark $USER
# sudo chmod +x /usr/bin/dumpcap # permissions fix

#####################################
# SHELL
#############################################
USER_SHELL="fish"
echo "Changing shell to $USER_SHELL..."
sudo usermod --shell /bin/$USER_SHELL $USER

# Symbolically link fish config in dotfiles to user's config folder
ln -s $HOME/.dotfiles/fish $HOME/.config/fish
ln -s $HOME/.dotfiles/config/starship.toml $HOME/.config/starship.toml

# Enter fish session
exec fish -l

#############################################
# OLD SHELL
#############################################
# # Download oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# # Download zsh fish-like plugins
# git clone git://github.com/hermitter/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/hermitter/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
# git clone https://github.com/hermitter/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# # Get zsh config
# cp $DOTFILES/zsh/zshrc $HOME/.zshrc
# # Change shell to zsh
# echo "Changing shell to zsh..."
# sudo usermod --shell /bin/fish $USER
# # Start zsh session
# exec zsh -l

#############################################
# WRAPPING UP
#############################################
echo -e '\nFINISHED INSTALLING: 2-install.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'
