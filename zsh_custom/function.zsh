# Function to set window Title
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
