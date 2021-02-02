" ===== Plugins ===== {{{
call plug#begin('~/.config/nvim/plugged')

Plug 'aquach/vim-http-client'
" TODO: base16-vim changed some colors that I don't like.
Plug 'chriskempson/base16-vim', { 'commit': '97f2feb' }
Plug 'editorconfig/editorconfig-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'mhinz/vim-grepper'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdtree'
Plug 'sfiera/vim-emacsmodeline'
Plug 'sheerun/vim-polyglot'
" forked neoterm due to https://github.com/kassio/neoterm/issues/108
Plug 'tail/neoterm', { 'branch': 'ipython-workaround' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-husk'

Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-xml', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-post', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'josa42/coc-docker', {'do': 'yarn install --frozen-lockfile'}
Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
Plug 'josa42/coc-sh', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}

call plug#end()
" }}}


" ===== Theme ===== {{{
let base16colorspace=256
set background=dark
silent! colorscheme base16-solarized-dark

" Override some defaults which I don't like.
hi Search ctermfg=21 guifg=#ffffff
hi pythonInclude ctermfg=4 guifg=#268bd2
" XXX: https://github.com/chriskempson/base16-vim/pull/132
hi MatchParen guifg=#002b36 guibg=#657b83 ctermfg=15 ctermbg=00
" }}}


" ===== Settings ===== {{{
set number
set smartcase
set ignorecase
set hidden  " for vim-ctrlspace

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set scrolloff=3
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db
set mouse=
" }}}

" ===== Conditional Settings ===== {{{
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
autocmd FileType yaml setlocal sw=2 sts=2
autocmd BufWritePre *.java call CocAction('runCommand', 'java.action.organizeImports')
" }}}


" ===== Keybindings ===== {{{
set pastetoggle=<F2>
map <F3> :NERDTreeTabsToggle<CR>
map! <F3> <ESC>:NERDTreeTabsToggle<CR>a
map <F4> :Vista!!<CR><C-w>l
map! <F4> <ESC>:Vista!!<CR><C-w>l
map <F5> oimport ipdb;ipdb.set_trace()<ESC>
map! <F5> <ESC>iimport ipdb;ipdb.set_trace()<CR>

map ,u :source ~/.config/nvim/init.vim<CR>
imap jk <ESC>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l:nohlsearch<CR>:redraw!<CR>:nohlsearch<CR>

nmap <leader>x <Plug>CommentaryLine
xmap <leader>x <Plug>Commentary
" clear trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" "zoom" current buffer (opens new tab with current buffer)
nmap <leader>z :tab split<CR>

" Search for selected text, forwards or backwards.
" From: http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" tab management
nnoremap <silent> <A-[> :tabprevious<CR>
nnoremap <silent> <A-]> :tabnext<CR>
nnoremap <silent> <A-{> :tabmove -1<CR>
nnoremap <silent> <A-}> :tabmove +1<CR>
" }}}


" ===== Aliases ===== {{{
command! -bang -nargs=* W w<bang> <args>
command! -bang -nargs=* Q q<bang> <args>
command! -bang -nargs=* Wq wq<bang> <args>
command! -bang -nargs=* WQ wq<bang> <args>
" }}}


" ===== neovim ===== {{{
if !empty(glob("~/.pyenv/versions/sandbox/"))
    let g:python_host_prog = glob("~/.pyenv/versions/sandbox/bin/python")
endif

if !empty(glob("~/.pyenv/versions/sandbox3/"))
    let g:python3_host_prog = glob("~/.pyenv/versions/sandbox3/bin/python")
endif
" }}}


" ===== coc ===== {{{
set updatetime=300
let g:coc_node_path = glob("~/.nvm/versions/node/") . $NODE_VERSION . "/bin/node"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
set tagfunc=CocTagFunc

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}


" ===== fzf ===== {{{
map <C-p> :GFiles<CR>
nnoremap <C-space> :Buffers<CR>
" }}}


" ===== ListToggle ===== {{{
" HACK: Breaking change in coc.nvim 0.0.79 (specifically commit e7f36979) no
" longer populates locationlist automatically, so the first time we need to
" make sure to call CocDiagnostics.

" track whether or not diagnostics were already laoded
let g:_coc_diagnostics_loaded = 0
" unbind default <leader>l
let g:lt_location_list_toggle_map = '<Plug>removeDefaultLocationListToggleMap'

function ToggleCocDiagnostics()
    if g:_coc_diagnostics_loaded == 0
        execute "CocDiagnostics"
        let g:_coc_diagnostics_loaded = 1
    else
        execute "LToggle"
    endif
endfunction
nnoremap <leader>l :call ToggleCocDiagnostics()<CR>
" }}}


" ===== neoterm ===== {{{
let g:neoterm_autoscroll = 1
let g:neoterm_auto_repl_cmd = 0
let g:neoterm_default_mod = 'bot'
xmap <leader>t :TREPLSendSelection<cr>
" }}}


" ===== vim-airline ===== {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'papercolor'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#vista#enabled = 1
" }}}


" ===== vim-emacsmodeline ===== {{{
let g:emacs_modelines=1
let g:emacsModeDict = {
    \ 'ruby': 'ruby',
    \ 'sls': 'sls',
    \ 'yaml': 'yaml',
\ }
" }}}


" ===== vim-grepper ===== {{{
nnoremap <leader>ag  :Grepper -nojump -tool ag -open -switch<cr>
nnoremap <leader>*   :Grepper -nojump -tool ag -open -switch -cword<cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

let g:grepper = {
    \ 'tools':     ['ag', 'git', 'grep'],
    \ 'open':      1,
    \ 'switch':    1,
    \ 'jump':      1,
    \ 'next_tool': '<leader>g',
    \ }
" }}}


" ===== vim-polyglot ===== {{{

" --- jsx ---
let g:jsx_ext_required = 0

" --- terraform ---
let g:terraform_fmt_on_save = 1

" }}}


" ===== vista ===== {{{
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
" }}}
