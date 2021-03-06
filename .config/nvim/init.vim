" Plugins
call plug#begin('~/.vimplugins')
Plug 'NLKNguyen/papercolor-theme'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sbdchd/neoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'leafOfTree/vim-vue-plugin'
Plug 'jwalton512/vim-blade'
Plug 'neovimhaskell/haskell-vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh'
    \ }
Plug 'rust-lang/rust.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'mhinz/vim-signify'
Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' }
Plug 'tmsvg/pear-tree'
Plug 'itchyny/lightline.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'mhinz/vim-startify'
Plug 'psliwka/vim-smoothie'
Plug 'preservim/nerdcommenter'
Plug 'preservim/tagbar'
Plug 'skywind3000/asyncrun.vim'
Plug 'machakann/vim-sandwich'
Plug 'APZelos/blamer.nvim'
Plug 'wincent/ferret'
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
set foldmethod=syntax
set foldlevelstart=10
if executable("rg") 
    set grepprg=rg\ --vimgrep 
endif
filetype plugin on
filetype plugin indent on

" Theme
set background=light
colorscheme PaperColor
highlight Normal guibg=white
highlight LineNr guibg=white
highlight ColorColumn guibg=lightgrey
let g:lightline = {
    \ 'colorscheme':'PaperColor_light'
    \ }
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [
    \ ['#4d4d4d', '#ffffff', 0, 15]
\ ]
let s:palette.normal.right = [
    \ ['#4d4d4d', '#f5f5f5', 0, 15],
    \ ['#4d4d4d', '#f5f5f5', 0, 15],
    \ ['#4d4d4d', '#f5f5f5', 0, 15]
\ ]

" Disable Leader Timeout
set notimeout
set ttimeout

" Remap Leader Key
let mapleader = ","

" Configuration Reload
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Configuration Edit
nnoremap <silent> <leader>ev :vs $MYVIMRC<CR>

" Toggle Highlight
nnoremap <silent><expr> <leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Quick Save
noremap <silent> <leader>ss :w<CR>

" Quick Build
noremap <silent> <leader>bb :let g:qfix_win = bufnr("$")<bar>AsyncRun bash/build.sh<CR>

" Quick Deploy
noremap <silent> <leader>dd :let g:qfix_win = bufnr("$")<bar>AsyncRun bash/deploy.sh<CR>

" Quick Fix Menu
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
noremap <silent> <leader>qf :QFix<CR>

" Window Quit
noremap <silent> <leader>wq :q<CR>

" Window Kill (quit after deleting current buffer)
noremap <silent> <leader>wk :bp<bar>sp<bar>bn<bar>bd<bar>q<CR>

" Buffer Previous/Next/List
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bl :buffers<CR>

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

" Rg
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" Fuzzy Finder
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fi :Rg<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git/'
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

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

" Tagbar Toggle
nnoremap <silent> <leader>tb :TagbarToggle<CR>

" Git Line Status
set updatetime=100

" Git Tool
nnoremap <silent> <leader>lg :LazyGit<CR>

" File Browser
let g:ranger_map_keys = 0
nnoremap <silent> <leader>fb :Ranger<CR>

" Async Run
let g:asyncrun_open = 8

" Rust / Cargo
let g:syntastic_rust_checkers = ['cargo']
let g:rustfmt_autosave = 1
nnoremap <silent> <leader>rsb :Cbuild<CR>
nnoremap <silent> <leader>rsr :Crun<CR>
nnoremap <silent> <leader>rst :Ctest<CR>
nnoremap <silent> <leader>rsc :Cclean<CR>
nnoremap <silent> <leader>rsd :Cdoc<CR>
