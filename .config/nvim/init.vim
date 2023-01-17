" Plugins
call plug#begin('~/.vimplugins')
Plug 'NLKNguyen/papercolor-theme'
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
Plug 'itchyny/vim-gitbranch'
Plug 'itchyny/lightline.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-repeat'
Plug 'ggandor/leap.nvim'
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
set shell=/usr/bin/zsh
if executable("rg") 
    set grepprg=rg\ --vimgrep 
endif
filetype plugin on
filetype plugin indent on

" Aliases
let $BASH_ENV = "~/.zsh_aliases"

" Theme
set background=light
colorscheme PaperColor
highlight Normal guibg=white
highlight LineNr guibg=white
highlight ColorColumn guibg=lightgrey
let g:lightline = {
    \ 'colorscheme':'PaperColor_light',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat ', 'fileencoding', 'filetype' ],
    \              [ 'gitbranch' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
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
nnoremap \ ,
xnoremap \ ,
onoremap \ ,
let mapleader = ","

" Configuration Reload
nnoremap <leader>sv :source $MYVIMRC<CR>

" Configuration Edit
nnoremap <leader>ev :vs $MYVIMRC<CR>

" Toggle Highlight
nnoremap <expr> <leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Quick Save
noremap <leader>ss :w<CR>

" Quick Build
noremap <leader>bb :let g:qfix_win = bufnr("$")<bar>AsyncRun bash/build.sh<CR>

" Quick Deploy
noremap <leader>dd :let g:qfix_win = bufnr("$")<bar>AsyncRun bash/deploy.sh<CR>

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
noremap <leader>qf :QFix<CR>

" Window Quit
noremap <leader>wq :q<CR>

" Window Kill (quit after deleting current buffer)
noremap <leader>wk :bp<bar>sp<bar>bn<bar>bd<bar>q<CR>

" Buffer Previous/Next/List
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bl :buffers<CR>

" Buffer Delete/Kill then Next Buffer
nnoremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>bk :bp<bar>sp<bar>bn<bar>bd!<CR>

" Terminal
autocmd TermOpen * startinsert
function! OpenTerminal()
  vsplit term://zsh
endfunction
nnoremap <leader>te :call OpenTerminal()<CR>
" tnoremap <Esc> <C-\><C-n>:bd!<CR>

" Formatter
let g:neoformat_try_node_exe = 1
nnoremap <leader>fm :Neoformat<CR>

" Project Tree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <leader>tr :NERDTreeToggle<CR>

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
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fi :Rg<CR>
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
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Leap
nmap <leader>jj <Plug>(leap-forward-to)
nmap <leader>jt <Plug>(leap-forward-till)
nmap <leader>jJ <Plug>(leap-backward-to)
nmap <leader>jT <Plug>(leap-backward-till)
nmap <leader>jw <Plug>(leap-cross-window)
lua require('leap').opts.case_sensitive = true
lua require('leap').opts.special_keys.next_target = '<tab>' 
lua require('leap').opts.special_keys.prev_target = '<s-tab>' 

" Tagbar Toggle
nnoremap <leader>tb :TagbarToggle<CR>

" Git Line Status
set updatetime=100

" Git Tool
nnoremap <leader>lg :LazyGit<CR>

" File Browser
let g:ranger_map_keys = 0
nnoremap <leader>fb :Ranger<CR>

" Async Run
let g:asyncrun_open = 8

" Rust / Cargo
let g:syntastic_rust_checkers = ['cargo']
let g:rustfmt_autosave = 1
nnoremap <leader>rsb :Cbuild<CR>
nnoremap <leader>rsr :Crun<CR>
nnoremap <leader>rst :Ctest<CR>
nnoremap <leader>rsc :Cclean<CR>
nnoremap <leader>rsd :Cdoc<CR>

