# Terminal Colors
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

# Path to your oh-my-zsh installation.
export ZSH="/home/carlos/.oh-my-zsh"

# General Settings
ZSH_THEME="dallas"
COMPLETION_WAITING_DOTS="true"

plugins=(zsh-syntax-highlighting git zsh-autosuggestions history-substring-search)

# User configuration
git config --global pager.branch false
alias docker="podman"
alias clear="tput reset"
alias mirrorup="sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syyu"
alias volume="pavucontrol"
alias sony="bluetoothctl connect CC:98:8B:D2:0C:8B"

# Imports
source $ZSH/oh-my-zsh.sh
source ~/.profile

# Shell Prompt
eval "$(starship init zsh)"