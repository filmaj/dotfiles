syntax enable
filetype plugin indent on

" line numbers
set number

" scroll with mouse
set mouse=a

" tabs, fuck no: spaces.
set tabstop=2
set expandtab
set shiftwidth=2

" max 80 chars per line, and auto-indent
set formatoptions-=l
autocmd FileType md setlocal formatoptions+=a
autocmd FileType html,sh,svelte setlocal formatoptions-=t
" toggle paste mode with \+o. like a high five.
nmap \o set paste!<CR>

" delete without yanking
nnoremap d "_d
vnoremap d "_d
nnoremap x "_x
nnoremap c "_c
vnoremap c "_c

" replace currently selected text with default register
" without yanking it
vnoremap p "_dP

" Ctrl-w Ctrl+v Ctrl-] to split vertically when chasing down a tag
nnoremap <C-W><C-V>[ :exec "vert norm <C-V><C-W>["<CR>

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
let g:airline#extensions#ale#enabled = 1

let g:ale_maximum_file_size = 500000  " Don't lint large files (> 500KB), it can slow things down
let g:ale_deno_unstable = 1 " use the --unstable flag w/ deno
" define which linter to use for which language
let g:ale_linters = {}
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.typescript = ['eslint', 'deno']
let g:ale_linters.python = ['flake8']
let g:ale_linters.hack = ['hack', 'hhast']
" for the linter that support fixing, define them here.
let g:ale_fixers = {}
let g:ale_fixers.javascript = ['eslint']
" Only run linters named in ale_linters settings.
" let g:ale_linters_explicit = 1

" auto-fix on save
" let g:ale_fix_on_save = 1

" show type on hover in a floating bubble
if v:version >= 801
  set balloonevalterm
  let g:ale_set_balloons = 1
  let balloondelay = 250
endif

" vim-go settings
let g:go_diagnostics_enabled = 1
let g:go_auto_type_info = 1
let g:go_metalinter_command = "golangci-lint"
let g:go_metalinter_autosave = 1

" vim-javascript settings
let g:javascript_plugin_jsdoc = 1

" CoC (code completion) extensions
let g:coc_global_extensions = ['coc-tsserver', 'coc-go', 'coc-java', 'coc-pyright']

" add tag generation status to the status bar
set statusline+=%{gutentags#statusline()}
let g:gutentags_ctags_exclude = ['*.git', '*.svg', '*.hg', '*/tests/*', 'coverage', 'dist']
" , 'build', 'dist', '*sites/*/files/*', 'node_modules', 'bower_components', 'cache', 'compiled', 'docs', 'example', 'bundle', 'vendor', '*.md', '*-lock.json', '*.lock', '*bundle*.js', '*build*.js', '.*rc*', '*.json', '*.min.*', '*.map', '*.bak', '*.zip', '*.pyc', '*.class', '*.sln', '*.Master', '*.csproj', '*.tmp', '*.csproj.user', '*.cache', '*.pdb', 'cscope.*', '*.css', '*.less', '*.scss', '*.exe', '*.dll', '*.mp3', '*.ogg', '*.flac', '*.swp', '*.swo', '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2', '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx']
let g:gutentags_define_advanced_commands = 1
" let g:gutentags_trace = 1
let g:gutentags_cache_dir = expand('~/.cache/tags')

" associate .es6 extension with javascript
au BufRead,BufNewFile *.es6 set filetype=javascript
au BufRead,BufNewFile *.htl set filetype=html
au BufRead,BufNewFile *.svelte set filetype=svelte

" set groovy for Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile setf groovy

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
