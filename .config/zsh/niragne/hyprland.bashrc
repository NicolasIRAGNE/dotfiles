# takes a string as param and attemps to exec $HOME/.config/hypr/monitors/<mon>.sh
function hyprmon-load()
{
    if [[ -z $1 ]]; then
        echo "Usage: hyprload-mon <mon>"
        return 1
    fi

    # if requested monitor is already loaded, do nothing
    if [[ $HYPR_MON == $1 ]]; then
        return 0
    fi

    # if requested monitor does not exist, load `base`
    if [[ ! -f $HOME/.config/hypr/monitors/$1.sh ]]; then
        echo "Monitor $1 does not exist, loading base"
        hyprmon-load base
        return 0
    fi

    # stop swww daemon
    swww kill

    # load requested monitor
    source $HOME/.config/hypr/monitors/$1.sh
    export HYPR_MON=$1

    # restart swww daemon
    swww start
}

function hyprmon-reset()
{

    monitor_ids=$(hyprctl monitors | grep -oP 'Monitor \K[^ ]+' | cut -d' ' -f2 | cut -d'(' -f2 | tr -d ')')
    while read -r monitor_id; do
        hyprctl keyword monitor $monitor_id,disable
    done <<< "$monitor_ids"
}

alias wb="pkill waybar ; hyprctl dispatch exec waybar"