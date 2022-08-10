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

" show type on hover in a floating bubble
if v:version >= 801
  set balloonevalterm
  let balloondelay = 250
endif

" CoC (code completion) extensions
let g:coc_global_extensions = ['coc-deno', 'coc-tsserver', 'coc-go', 'coc-java', 'coc-pyright', 'coc-json', 'coc-eslint']
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Use <c-space> to trigger completion in insert mode, or show documentation in
" normal mode.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
  nnoremap <silent> <c-space> :call ShowDocumentation()<CR>
else
  inoremap <silent><expr> <c-@> coc#refresh()
  nnoremap <silent> <c-@> :call ShowDocumentation()<CR>
endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use K to show documentation in preview window.
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Tweaking colours used in vim w/ coc.nvim
highlight Conceal ctermfg=7 ctermbg=0

au BufRead,BufNewFile *.svelte set filetype=svelte
" set groovy for Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile setf groovy

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
