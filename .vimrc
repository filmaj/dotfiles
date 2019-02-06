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

" max 80 chars per line, and auto-indent
set textwidth=80
set formatoptions-=l
autocmd FileType md setlocal formatoptions+=a
autocmd FileType html,py setlocal formatoptions-=a

" toggle paste mode with \+o. like a high five.
nmap \o set paste!<CR>

set incsearch
set ignorecase
set smartcase
set hlsearch
set backspace=indent,eol,start
set noswapfile

execute pathogen#infect()

colorscheme hybrid
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" disable folding w/ vim-markdown
let g:vim_markdown_folding_disabled=1
set nofoldenable

" have vim-airline statusbar show at all times
set laststatus=2
let g:airline_theme='distinguished'

let g:ale_maximum_file_size = 500000  " Don't lint large files (> 500KB), it can slow things down
" define which linter to use for which language
let g:ale_linters = {}
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.python = ['flake8']
" for the linter that support fixing, define them here.
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['eslint']
" auto-fix on save
let g:ale_fix_on_save = 1

" associate .es6 extension with javascript
au BufRead,BufNewFile *.es6 set filetype=javascript
au BufRead,BufNewFile *.yml,*.yaml set filetype=ansible

" set groovy for Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile setf groovy
