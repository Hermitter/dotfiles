#!/bin/sh
class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
icon=""

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')

  if [[ ${#info} -eq 3 ]]; then
    info=""
  elif [[ ${#info} -gt 30 ]]; then
    info=$(echo $info | cut -c1-30)"..."
  fi

  text=$icon" "$info

elif [[ $class == "paused" ]]; then
  text=$icon" PAUSED"
elif [[ $class == "stopped" ]]; then
  text=""
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
