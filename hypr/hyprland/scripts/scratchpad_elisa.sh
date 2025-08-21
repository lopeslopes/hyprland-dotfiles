#!/bin/bash

## DEBUG OPTIONS
# LOGFILE="/tmp/scratchpad-elisa.log"
#
# exec > >(tee -a "$LOGFILE") 2>&1
# echo "---- Run at $(date) ----"
#
# set -x

APP_CLASS="org.kde.elisa"
APP_CMD="elisa"

# If Elisa is already running, and we're toggling ON, reposition it
if hyprctl clients -j | jq -e '.[] | select(.workspace.name=="special:music")' > /dev/null; then
    # Give Hyprland a moment to actually map the special workspace
    sleep 0.05

    # Get Elisa window address
    ELISA_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class=="org.kde.elisa") | .address')

    if [ -n "$ELISA_ADDR" ]; then
        # Get monitor dimensions
        eval $(hyprctl -j monitors | jq -r '.[] | select(.focused==true) |
            "X=\(.x) Y=\(.y) W=\(.width) H=\(.height) T=\(.transform)"')

        WIN_W=768
        WIN_H=465

        POS_X=$(( X + (W - WIN_W) / 2 ))
        POS_Y=$(( Y + H - WIN_H ))
        if [[ "$T" == "1" || "$T" == "3" ]]; then
            POS_X=$(( X + (H - WIN_W) / 2 ))  # horizontally centered in long axis
            POS_Y=$(( Y + W - WIN_H - PAD ))  # bottom in short axis
        fi

        hyprctl dispatch resizewindowpixel exact "$WIN_W" "$WIN_H,address:$ELISA_ADDR"
        hyprctl dispatch movewindowpixel exact "$POS_X" "$POS_Y,address:$ELISA_ADDR"
    fi
    hyprctl dispatch togglespecialworkspace music
    exit 0
fi


# If Elisa is not running, launch it
if ! pgrep -x "elisa" > /dev/null; then
    $APP_CMD & disown
    sleep 1
fi

# Get active monitor geometry (x y width height transform)
read -r X Y W H T <<<$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | "\(.x) \(.y) \(.width) \(.height) \(.transform)"')

# Desired window size
WIN_W=768
WIN_H=465
PAD=0

# Default: bottom center
POS_X=$(( X + (W - WIN_W) / 2 ))
POS_Y=$(( Y + H - WIN_H - PAD ))

# If monitor is vertical rotated (90° or 270°)
if [[ "$T" == "1" || "$T" == "3" ]]; then
    POS_X=$(( X + (H - WIN_W) / 2 ))  # horizontally centered in long axis
    POS_Y=$(( Y + W - WIN_H - PAD ))  # bottom in short axis
fi

# Show special workspace
hyprctl dispatch togglespecialworkspace music
sleep 0.05

# Apply move + resize to Elisa and focus it
for WIN in $(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_CLASS\") | .address"); do
    hyprctl dispatch resizewindowpixel exact $WIN_W $WIN_H,address:$WIN
    hyprctl dispatch movewindowpixel exact $POS_X $POS_Y,address:$WIN
    hyprctl dispatch focuswindow address:$WIN
done
