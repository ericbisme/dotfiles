" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

if exists('*minpac#init')
  " minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Additional plugins here.

  call minpac#add('scrooloose/nerdtree')
  call minpac#add('Xuyuanp/nerdtree-git-plugin')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('airblade/vim-gitgutter')

  " Languages
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('rodjek/vim-puppet')

  " Syntax highligting
  call minpac#add('w0rp/ale')

  " Make the status line pretty
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-airline/vim-airline-themes')

  " Themes
  call minpac#add('altercation/vim-colors-solarized')

endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdateAndQuit packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'quit'})
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

" Airline
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Colors
set background=dark
colorscheme solarized

" Settings
syntax on
filetype plugin indent on

" Indents
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set breakindent
set smartindent
set nofoldenable
set colorcolumn=80
set foldmethod=syntax
set foldlevelstart=5

" Auto Commands
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
