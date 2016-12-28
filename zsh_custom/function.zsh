#!/bin/zsh
## Function to set window Title
settitle() {
    printf "\033k$1\033\\"
}

# Change tmux/screen title on ssh
ssh() {
    settitle "$*"
    command ssh "$@"
    settitle `hostname -s`
}

ansible-sh() {
    ansible $1 -m shell -a $2
}

rdp() {
    if [ ! -d ~/.dotfiles/remmina ]; then
      echo ".remmina does not exist in your home directory"
      return 1
    fi

    ping -c1 -W1 $1 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
       echo "Server $1 is not reachable"
       return 1
    fi

    #local CONFIG=`grep -l "server=$1" ~/.dotfiles/remmina/*.remmina`
    local CONFIG=$(/usr/bin/grep -l "server=$1" $HOME/.remmina/*.remmina)
    echo $CONFIG
    if [ $? -ne 0 ]; then
       echo "Server $1 is not available in your Remmina configurations"
       return 1
    fi

    nohup remmina -c $CONFIG > /dev/null 2>&1 &
}