syntax enable
let g:solarized_termcolors=256
color solarized
set background=dark
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

" enter to go to end of file, backspace to beginning
nnoremap <CR> G
nnoremap <BS> gg

execute pathogen#infect()

" disable folding w/ vim-markdown
let g:vim_markdown_folding_disabled=1
set nofoldenable

" use pyflakes for syntax checking in python
let g:syntastic_python_checkers = ['pyflakes']
