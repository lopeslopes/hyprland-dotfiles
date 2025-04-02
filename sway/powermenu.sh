#!/usr/bin/env bash

entries="⇠ Logout\n Suspend\n↻ Reboot\n⏻ Shutdown"

selected=$(echo -e $entries|wofi --width 250 --height 245 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
  logout)
    swaymsg exit;;
  suspend)
    systemctl suspend;;
  reboot)
    systemctl reboot;;
  shutdown)
    systemctl poweroff -i;;
esac
