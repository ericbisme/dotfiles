#!/bin/sh
# Bootstrap this dotfiles checkout. Supports macOS and Fedora.
#
# Idempotent - safe to re-run at any time.
#
# Scope: this script LINKS configuration into place and REPORTS missing
# dependencies. It deliberately does not install packages. Guessing package
# names across brew and dnf is how a bootstrap script rots; on work machines
# the workstation-setup Ansible playbook owns installation.
set -eu

# Logical path, not physical: ~/.dotfiles may itself be a symlink, and the
# links we create should read as ~/.dotfiles/... rather than wherever that
# happens to point on this machine.
DOTFILES=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
OS=$(uname -s)

info() { printf '  %s\n' "$*"; }
warn() { printf 'bootstrap: %s\n' "$*" >&2; }
die() { printf 'bootstrap: %s\n' "$*" >&2; exit 1; }

# Portable symlinking. BSD/macOS ln has no -T, so never use it; instead clear
# the destination first and create a plain -s link.
link() {
  src=$1
  dst=$2

  if [ -L "$dst" ]; then
    [ "$(readlink "$dst")" = "$src" ] && return 0
    rm -f -- "$dst"
  elif [ -d "$dst" ]; then
    warn "$dst is a real directory, not a symlink - leaving it alone"
    return 0
  elif [ -e "$dst" ]; then
    warn "$dst exists and is not a symlink - moving it to $dst.bak"
    mv -- "$dst" "$dst.bak"
  fi

  ln -s -- "$src" "$dst"
  info "linked ${dst#"$HOME"/} -> ${src#"$HOME"/}"
}

[ -d "$DOTFILES" ] || die "cannot locate the dotfiles directory"
printf 'bootstrap: %s on %s\n' "$DOTFILES" "$OS"

# ---------------------------------------------------------------- $HOME files
# Every *.symlink becomes ~/.<name>, so vimrc.after.symlink -> ~/.vimrc.after.
# These are intentionally cross-platform: Xresources and the vim configs are
# inert on macOS but are the real thing on Fedora.
printf '\nLinking home dotfiles:\n'
for src in "$DOTFILES"/*.symlink; do
  [ -e "$src" ] || continue
  name=${src##*/}
  link "$src" "$HOME/.${name%.symlink}"
done

# ---------------------------------------------------------------------- nvim
# The whole directory is linked, so init.lua and lua/ come with it. lazy.nvim
# bootstraps itself on first launch and installs the revisions pinned in
# lazy-lock.json, so there is no plugin manager to clone here.
printf '\nLinking nvim config:\n'
mkdir -p "$HOME/.config"
link "$DOTFILES/config/nvim" "$HOME/.config/nvim"

# ------------------------------------------------------------------ oh-my-zsh
# NOTE: ZSH_CUSTOM is deliberately left at its default (~/.oh-my-zsh/custom),
# NOT pointed at this repo's zsh_custom/. See README.
if command -v zsh >/dev/null 2>&1 && [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf '\nInstalling oh-my-zsh:\n'
  # curl, not wget: macOS ships curl and not wget.
  command -v curl >/dev/null 2>&1 || die "curl is required to install oh-my-zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ----------------------------------------------------------------------- ssh
# Only create ~/.ssh/config if absent; it is hand-maintained and must not be
# clobbered. Otherwise just check that it pulls in this repo's config.d.
printf '\nChecking ssh config:\n'
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -e "$HOME/.ssh/config" ]; then
  {
    printf 'Include ~/.ssh/config.d/*\n'
    printf 'Include %s/ssh/config.d/*\n' "$DOTFILES"
  } >"$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  info "created $HOME/.ssh/config"
elif grep -q 'dotfiles/ssh/config.d' "$HOME/.ssh/config" 2>/dev/null; then
  info "$HOME/.ssh/config already includes this repo"
else
  warn "$HOME/.ssh/config does not include $DOTFILES/ssh/config.d/* - add it manually"
fi

# ---------------------------------------------------------------- X resources
# Linux/X11 only. No-op on macOS and on Wayland-only sessions.
if command -v xrdb >/dev/null 2>&1 && [ -f "$HOME/.Xresources" ]; then
  printf '\nMerging .Xresources:\n'
  xrdb -merge "$HOME/.Xresources"
  info "merged"
fi

# ------------------------------------------------------------------ git hooks
# Versioned hooks: core.hooksPath means hooks/ is used directly, with no copy
# step to forget. Requires git >= 2.9.
printf '\nEnabling versioned git hooks:\n'
if git -C "$DOTFILES" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$DOTFILES" config core.hooksPath hooks
  info "core.hooksPath = hooks"
else
  warn "not a git checkout - skipping hooks"
fi

# --------------------------------------------------------------- dependencies
# Reported, not installed. Anything missing degrades a specific feature.
printf '\nDependencies:\n'
hint() {
  case "$OS" in
    Darwin) printf 'brew install %s' "$1" ;;
    Linux) printf 'sudo dnf install %s' "$1" ;;
    *) printf 'install %s' "$1" ;;
  esac
}

check() { # check <command> <package> <what it is for>
  if command -v "$1" >/dev/null 2>&1; then
    info "ok       $1"
  else
    info "MISSING  $1 - $3 ($(hint "$2"))"
  fi
}

check git git "version control"
check zsh zsh "the shell these dotfiles configure"
check nvim neovim "editor"
check tmux tmux "terminal multiplexer"
# nvim-treesitter on branch=main compiles parsers with the tree-sitter CLI.
# Without it, highlighting silently stays off. Note the package is
# tree-sitter-cli on Homebrew - the plain tree-sitter formula is the library
# only. On Fedora, `cargo install tree-sitter-cli` if dnf has no package.
check tree-sitter tree-sitter-cli "treesitter parser compilation"
check shellcheck ShellCheck "the pre-commit hook"
check autojump autojump "the autojump zsh plugin"
check mr myrepos "multi-repo management (see mrconfig.d/)"

printf '\nbootstrap: done\n'
