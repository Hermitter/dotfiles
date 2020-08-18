set -e

config="$HOME/.config/sway"
background="$HOME/Pictures/Wallpapers/default.jpg"

# swaylock --clock --datestr '%d.%m.%Y' --indicator -ef -i $background
swaylock -e -f --image $background