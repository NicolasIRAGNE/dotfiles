################################################################################
# File: mod_opacity.sh
# Created Date: 05/11/2023
# Author: Nicolas Iragne (nicolas.iragne@shadow.tech)
# -----
# Helper script to increase or decrease the opacity of all windows
# -----
################################################################################

active_opacity=$(hyprctl getoption decoration:active_opacity -j | jq -r '.float')
inactive_opacity=$(hyprctl getoption decoration:inactive_opacity -j | jq -r '.float')

echo -n "Switching opacity from $active_opacity:$inactive_opacity to "

if [ "$#" = "2" ]; then
    active_opacity=$(echo "$active_opacity $1 $2" | bc)
    inactive_opacity=$(echo "$inactive_opacity $1 $2" | bc)
else
    active_opacity="0.98"
    inactive_opacity="0.92"
fi

echo "$active_opacity:$inactive_opacity"

hyprctl --batch "keyword decoration:active_opacity $active_opacity; keyword decoration:inactive_opacity $inactive_opacity"
