function powerline_precmd() {
    PS1="$(~/.bin/powerline-go -error $? -shell zsh -modules aws,venv,kube,cwd,git -cwd-max-depth 2)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
