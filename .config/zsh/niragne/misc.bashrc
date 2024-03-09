if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
elif [[ $XDG_SESSION_TYPE == "x11" ]]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS='--height 50% --border'

export PATH="$HOME/.local/bin:$PATH"

# if TERM is not xterm
if [[ "$TERM" != "xterm" ]]; then
  bindkey '^H' backward-kill-word
  bindkey '5~' kill-word
fi

ssh-edit() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: ssh-edit <remote_file> <host1> [<host2> ...]"
    return 1
  fi

  local remote_file=$1
  shift
  local hosts=("$@")
  local local_file=$(basename "$remote_file")
  local_file="/tmp/$local_file"

  edit_file() {
    if [ -n "$EDITOR" ]; then
      eval "$EDITOR \"$1\""
    else
      vim "$1"
    fi
  }

  for host in "${hosts[@]}"; do
    echo "Processing $host..."

    rm -f "$local_file"
    # Download the remote file to edit locally
    scp "$host:$remote_file" "$local_file"
    if [ "$?" -ne 0 ]; then
      echo "Failed to download file from $host."
      echo "It will be created locally and uploaded back to $host."
    fi

    # Open the file with the specified editor
    edit_file "$local_file"

    # Upload the edited file back to the remote server
    scp "$local_file" "$host:$remote_file"
    if [ "$?" -ne 0 ]; then
      echo "Failed to upload file to $host."
      return 1
    fi

    echo "File successfully edited and uploaded back to $host."
  done
}

alias -g OSEF='2>/dev/null'
alias -g FTG='&>/dev/null'
alias -g MENFOU='&>/dev/null'
alias -g MENBRANLE='&>/dev/null'
alias -g RIENAFOUTRE='&>/dev/null'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias golmon=go

function h()
{
  gh copilot suggest $@
}

eval $(thefuck --alias)

if command -v exa &> /dev/null; then
    alias ls='exa'
else
    echo "$0:$LINENO WARN: exa not found, not replacing ls"
fi
