alias vpn='sudo openconnect --juniper --background --quiet --user=bolinger vpn.cusys.edu'
alias psa='mosh dpsaadm01.dev.cu.edu -- tmux a -t eab0'
alias thepit='mosh thepit.homelinux.net --ssh="ssh -p 2222" -- tmux a -t eab0'

# Wake On Lan
alias wol_esb='sudo ether-wake b8:ae:ed:e9:8c:a4'
alias wol_wit='sudo ether-wake 34:e6:d7:47:6c:c0'
alias wol_porter='sudo ether-wake 00:1f:c6:9b:98:36'

# Kubernetes
#alias kc='kubectl'
#alias kcga='kubectl get all'

# vi to neovim
alias vi=nvim
