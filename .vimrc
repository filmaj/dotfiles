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

set incsearch
set ignorecase
set smartcase
set hlsearch
set backspace=indent,eol,start
set noswapfile
set number relativenumber

" silent vim
set visualbell
set t_vb=

" automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
execute pathogen#infect()

colorscheme hybrid
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" fuzzy finder fzf integration
set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" additional ag options; ag_raw defaults also include --nogroup --column
" --color
let s:ag_options = ' --ignore-dir node_modules --ignore-dir .git --ignore package-lock.json --ignore deno.lock '
" use :Ag for fuzzy finding via `ag`, and :Ag! for full screen find
command! -bang -nargs=* Ag
        \ call fzf#vim#ag(
        \   <q-args>,
        \   s:ag_options,
        \  <bang>0 ? fzf#vim#with_preview('up:60%')
        \        : fzf#vim#with_preview('right:50%', '?'),
        \   <bang>0
        \ )

" disable folding w/ vim-markdown
let g:vim_markdown_folding_disabled = 1
set nofoldenable
let g:vim_markdown_new_list_item_indent = 2

" have vim-airline statusbar show at all times
set laststatus=2
let g:airline_theme='distinguished'
let g:airline#extensions#ale#enabled = 1

" vim-javascript settingslet
let g:javascript_plugin_jsdoc = 1

" show type on hover in a floating bubble
if v:version >= 801 && !has('nvim')
  set balloonevalterm
  let balloondelay = 250
endif

" CoC (code completion) extensions
" let g:coc_global_extensions = ['coc-deno', 'coc-tsserver', 'coc-pyright', 'coc-json', 'coc-eslint']
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
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"  nnoremap <silent> <c-space> :call ShowDocumentation()<CR>
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"  nnoremap <silent> <c-@> :call ShowDocumentation()<CR>
"endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use K to show documentation in preview window.
"function! ShowDocumentation()
"  if CocAction('hasProvider', 'hover')
"    call CocActionAsync('doHover')
"  else
"    call feedkeys('K', 'in')
"  endif
"endfunction
" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>
"nmap <silent> gv :call CocAction('jumpDefinition', 'vsplit')<CR>
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"function! s:disable_coc_for_type()
"  let l:filesuffix_blacklist = ['md']
"  if index(l:filesuffix_blacklist, expand('%:e')) != -1
"    let b:coc_enabled = 0
"  endif
"endfunction
"autocmd BufRead,BufNewFile * call s:disable_coc_for_type()
" Tweaking colours used in vim w/ coc.nvim
"highlight Conceal ctermfg=7 ctermbg=0

" Remove plugin name showing in border from context.vim
let g:context_highlight_tag = '<hide>'

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
