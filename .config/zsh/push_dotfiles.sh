#!/bin/env zsh
################################################################################
# File: push_dotfiles.sh
# Created Date: 04/12/2023
# Author: Nicolas Iragne (nicolas.iragne@shadow.tech)
# -----
# This script is used to automatically push the dotfiles to the git repository
# and warn the user if there are any changes.
# In case of conflicts, abort the push.
# -----
################################################################################

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
LOGFILE=$HOME/.dotfiles_push.log

# Get tracked files
tracked_files=$(config ls-tree --full-tree -r --name-only HEAD)

# Get deleted files
deleted_files=$(config ls-files --deleted)

config add -u

if [ "$FAILED" = true ]; then
    # send notification
    notify-send "Dotfiles push failed" "Please check the dotfiles repository"
    echo "Check $LOGFILE for more details"
    exit 1
fi

# Construct commit message
commit_message="Automatic commit from $(hostname) on $(date '+%Y-%m-%d %H:%M:%S')"

echo "$commit_message"

# Commit changes
config commit -m "$commit_message"

# Push changes
config push &> $LOGFILE || FAILED=true

if [ "$FAILED" = true ]; then
    # send notification
    notify-send "Dotfiles push failed" "Please check the dotfiles repository"
    echo "Check $LOGFILE for more details"
    exit 1
fi
