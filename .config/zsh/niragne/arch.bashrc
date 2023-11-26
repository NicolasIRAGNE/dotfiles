alias aurinstall='function _aurinstall(){aur sync "$1" && sudo pacman -S "$1"}; _aurinstall'

alias kssh='function _kssh(){kitty +kitten ssh "$1"}; _kssh'

plugins+=(archlinux)
