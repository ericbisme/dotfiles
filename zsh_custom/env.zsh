GOPATH="~/go"
GOBIN="${GOPATH}/bin"

PATH="${HOME}/.bin:${HOME}/.dotfiles/bin:/home/bolinger/.cargo/bin:${KREW_ROOT:-$HOME/.krew}/bin:${GOPATH}/bin:${PATH}" && export PATH;

FLUX_FORWARD_NAMESPACE=flux && export FLUX_FORWARD_NAMESPACE;
