#!/bin/bash

entries="⇠ Logout\n⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"
# entries="Logout\nSuspend\nReboot\nShutdown"


selected=$(echo -e $entries|wofi --width 250 --height 245 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')
# selected=$(echo -e $entries|wofi --width 250 --height 245 --dmenu --cache-file /dev/null | awk '{print tolower($0)}')

case $selected in
  logout)
    hyprctl dispatch exit;;
  suspend)
    systemctl suspend;;
  reboot)
    systemctl reboot;;
  shutdown)
    systemctl poweroff -i;;
esac
