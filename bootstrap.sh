# Make Required Directories
mkdir -p ~/go/bin
mkdir -p ~/.config/nvim/pack/minpac/opt

#Oh-My-ZSH
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sh -c "$(wget -q -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerline Go
wget -q -O ~/go/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.13.0/powerline-go-linux-amd64
chmod +x ~/go/bin/powerline-go

# Stern
wget -q -O ~/go/bin/stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
chmod +x ~/go/bin/stern

# neovim
ln -s ~/.dotfiles/init.vim.symlink ~/.config/nvim/init.vim
git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
/usr/bin/nvim --headless -c PackUpdateAndQuit

# Symlink Simple Configs
ln -s ~/.dotfiles/tmux.conf.symlink ~/.tmux.conf
ln -s ~/.dotfiles/zshrc.symlink ~/.zshrc.symlink
#ln -s ~/.dotfiles/vimrc.after.symlink ~/.vimrc.after
#ln -s ~/.dotfiles/vimrc.symlink ~/.vimrc
