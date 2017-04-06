" ===== Plugins ===== {{{
" From https://github.com/junegunn/vim-plug/issues/125
function! UpdateRPlugin(info)
    if has('nvim')
        silent UpdateRemotePlugins
        echomsg 'rplugin updated: ' . a:info['name'] . ', restart vim for changes'
    endif
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'autowitch/hive.vim'
Plug 'carlitux/deoplete-ternjs'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'derekwyatt/vim-scala'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'keith/swift.vim'
Plug 'klen/python-mode'
Plug 'majutsushi/tagbar'
Plug 'maksimr/vim-jsbeautify'
Plug 'mhartington/nvim-typescript'
Plug 'mhinz/vim-grepper'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': function('UpdateRPlugin') }
Plug 'smerrill/vcl-vim-plugin'
Plug 'steelsojka/deoplete-flow'
Plug 'szw/vim-ctrlspace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
" TODO: Hard-coding to SHA right before PR 911.
" Something with ctrlspace integration and buffers makes it so that buffers
" always show on the left and tabs on the right.
" Culprit:
"   https://github.com/vim-airline/vim-airline/pull/911
" Relevant reading:
"   https://github.com/vim-airline/vim-airline/issues/639
"   https://github.com/vim-airline/vim-airline/issues/1043
Plug 'vim-airline/vim-airline', { 'commit': 'e7de5f451a26eb2138d710e59a3e7b95a848a901' }
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-husk'
Plug 'w0rp/ale'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go'

call plug#end()
" }}}


" ===== Theme ===== {{{
let base16colorspace=256
set background=dark
silent! colorscheme base16-solarized-dark

" Override some defaults which I don't like.
hi Search ctermfg=21 guifg=#ffffff
hi pythonStatement ctermfg=5 guifg=#6c71c4
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
autocmd FileType yaml setlocal sw=2 sts=2
autocmd BufNewFile,BufRead *.hql set filetype=hive
" }}}


" ===== Keybindings ===== {{{
set pastetoggle=<F2>
map <F3> :NERDTreeTabsToggle<CR>
map! <F3> <ESC>:NERDTreeTabsToggle<CR>a
map <F4> :TagbarToggle<CR><C-w>l
map! <F4> <ESC>:TagbarToggle<CR><C-w>l
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
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" TODO: re-enable if using ctrlspace instead of ctrlp.
" nnoremap <silent><C-p> :CtrlSpace O<CR>

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
" }}}


" ===== Aliases ===== {{{
command! -bang -nargs=* W w<bang> <args>
command! -bang -nargs=* Q q<bang> <args>
command! -bang -nargs=* Wq wq<bang> <args>
command! -bang -nargs=* WQ wq<bang> <args>
" }}}


" ===== ale ===== {{{
let g:ale_lint_on_text_changed = 'never'
" }}}


" ===== ctrlp ===== {{{
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v(\/node_modules|\/vendor|\.git|\.hg|\.svn|\.egg|\.egg-info$)',
    \ 'file': '\v(\.sw[a-z]\|\.py[co]|\.egg|\.class)$',
    \ }
if executable("ag")
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" }}}


" ===== deoplete ===== {{{
let g:deoplete#enable_at_startup = 1
" }}}


" ===== deoplete-flow ===== {{{
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))

if g:flow_path != 'flow not found'
  let g:deoplete#sources#flow#flow_bin = g:flow_path
endif
" }}}


" ===== deoplete-ternjs ===== {{{
let g:tern#filetypes = [
                \ 'jsx',
                \ ]
" }}}


" ===== python-mode ===== {{{
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_options_colorcolumn = 0
" Disable python-mode's completion which conflicts with deoplete.
let g:pymode_rope = 0
" }}}


" ===== vim-airline ===== {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#enabled = 1
" TODO: Tagbar is REALLY slow for large files.
let g:airline#extensions#tagbar#enabled = 0
" }}}


" ===== vim-ctrlspace ===== {{{
if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --hidden --nocolor -g ""'
endif

let g:CtrlSpaceSetDefaultMapping = 0
nnoremap <NUL> :CtrlSpace a<CR>
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


" ===== vim-jsx ===== {{{
let g:jsx_ext_required = 0
" }}}
