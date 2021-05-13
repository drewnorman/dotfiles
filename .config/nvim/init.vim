" Plugins
call plug#begin('~/.vimplugins')
Plug 'srcery-colors/srcery-vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'leafOfTree/vim-vue-plugin'
Plug 'mhinz/vim-signify'
Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' }
Plug 'tmsvg/pear-tree'
Plug 'vim-airline/vim-airline'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'mhinz/vim-startify'
Plug 'psliwka/vim-smoothie'
Plug 'preservim/nerdcommenter'
call plug#end()

" General
syntax enable
set termguicolors
set number
set relativenumber
set encoding=UTF-8
set splitright
set autoindent
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *.vue set ft=vue
autocmd FileType vue setlocal shiftwidth=2 tabstop=2
set colorcolumn=80
set textwidth=80
filetype plugin on

" Theme
colorscheme srcery
let g:airline_theme="srcery"

" Disable Leader Timeout
set notimeout
set ttimeout

" Configuration Reload
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Toggle Highlight
nnoremap <silent><expr> <leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Buffer Delete/Kill then Next Buffer
nnoremap <silent> <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <silent> <leader>bk :bp<bar>sp<bar>bn<bar>bd!<CR>

" Terminal
autocmd TermOpen * startinsert
function! OpenTerminal()
  vsplit term://zsh
endfunction
nnoremap <silent> <leader>te :call OpenTerminal()<CR>

" Project Tree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent> <leader>tr :NERDTreeToggle<CR>

" Fuzzy Finder
nnoremap <silent> <leader>ff :FZF<CR>
nnoremap <silent> <leader>fi :Rg<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_COMMAND = 'rg --files'

" Code Completion
let g:coc_global_extensions = ['coc-css', 'coc-html', 'coc-json', 'coc-phpls']
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

" Git Line Status
set updatetime=100

" Git Tool
nnoremap <silent> <leader>lg :LazyGit<CR>

" File Browser
let g:ranger_map_keys = 0
nnoremap <silent> <leader>fb :Ranger<CR>
