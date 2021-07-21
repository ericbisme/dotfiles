# Remote Connectivity
alias ptr='mosh porter.ericbisme.net -- tmux a -t eab0'
alias thepit='mosh thepit.homelinux.net -- tmux a -t eab0'

# Wake On Lan
alias wol_esb='sudo ether-wake b8:ae:ed:e9:8c:a4'
alias wol_wit='sudo ether-wake 34:e6:d7:47:6c:c0'
alias wol_porter='sudo ether-wake 00:1f:c6:9b:98:36'
alias wol_coreos='sudo ether-wake 00:30:48:94:c6:32'

# Kubernetes
#alias kc='kubectl'
#alias kcga='kubectl get all'
#alias kgn='kubectl'

alias vi=nvim
alias tg=terragrunt
alias tf=terraform

# AWS
alias aws-table="aws ec2 describe-instances --query 'Reservations[].Instances[].[ [Tags[?Key=='Name'].Value][0][0],PrivateIpAddress,InstanceId,State.Name,Placement.AvailabilityZone ]' --output table"
