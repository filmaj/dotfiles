syntax enable
filetype plugin indent on

" line numbers
set number

" scroll with mouse
set mouse=a

" tabs, fuck no: spaces. 
set tabstop=4
set expandtab
set shiftwidth=4

" toggle paste mode with \+o. like a high five.
nmap \o set paste!<CR>  

set incsearch
set ignorecase
set smartcase
set hlsearch
set backspace=indent,eol,start

execute pathogen#infect()

colorscheme hybrid
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" disable folding w/ vim-markdown
let g:vim_markdown_folding_disabled=1
set nofoldenable

" use pyflakes for syntax checking in python
let g:syntastic_python_checkers = ['pyflakes']

" have vim-airline statusbar show at all times
set laststatus=2

" associate .es6 extension with javascript
au BufRead,BufNewFile *.es6 set filetype=javascript
