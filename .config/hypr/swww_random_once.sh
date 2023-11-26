#!/bin/bash

# This script will randomly select a file from a directory and set it
# up as the wallpaper
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=144
export SWWW_TRANSITION_STEP=2

echo "Setting up random wallpaper from $1"

# select one random image from the directory and set it as wallpaper
find "$1" -type f \
	| shuf -n 1 \
	| while read -r img; do
		swww img "$img" --transition-type random
		echo "Wallpaper set to $img"
	done