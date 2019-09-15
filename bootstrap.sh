# Make Required Directories
mkdir -p ${HOME}/.bin

#Oh-My-ZSH
if [ $(command -v zsh) ] ; then
  # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  [ ! -d ~/.oh-my-zsh ] && sh -c "$(wget -q -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Symlink Simple Configs
# all files and directories that that end in ".symlink" will be converted to symlinks in $HOME
find ~/.dotfiles -name "*.symlink" -exec sh -c 'f="{}"; t="${f##*/}"; t="${t%.*}"; ln -sTf $f "$HOME/.$t"' \;

# Xterm Configs
if [ $(command -v xterm) ] ; then
  echo "Merging .Xresources"
  xrdb -merge ${HOME}/.Xresources
fi

# neovim
if [ $(command -v nvim) ] ; then
  # .config directory
  [ ! -e ~/.config/nvim ] && mkdir -p ~/.config/nvim/pack/minpac/opt && ln -s ~/.dotfiles/config/nvim/init.vim ~/.config/nvim/init.vim

  # minpac plugins manager
  MINPAC_DIR=~/.config/nvim/pack/minpac/opt/minpac
  MINPAC_GIT=https://github.com/k-takata/minpac.git
  if [ ! -d "$MINPAC_DIR" ] ; then
    git clone $MINPAC_GIT $MINPAC_DIR
    /usr/bin/nvim --headless -c PackUpdateAndQuit
  else
    cd "$MINPAC_DIR"
    git pull $MINPAC_GIT
    #/usr/bin/nvim --headless -c PackUpdateAndQuit
  fi
fi

# Utilities
export VERSION="v1.13.0" && wget -q -O ${HOME}/.bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/${VERSION}/powerline-go-linux-amd64 # Powerline Go
export VERSION="1.11.0"  && wget -q -O ${HOME}/.bin/stern https://github.com/wercker/stern/releases/download/${VERSION}/stern_linux_amd64 # Stern

chmod +x ${HOME}/.bin/*
