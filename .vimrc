" ===== Plugins ===== {{{
call plug#begin('~/.vim/plugged')

Plug 'autowitch/hive.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'klen/python-mode'
Plug 'majutsushi/tagbar'
Plug 'maksimr/vim-jsbeautify'
Plug 'mhinz/vim-grepper'
Plug 'neomake/neomake'
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/neocomplete.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-husk'

call plug#end()
" }}}


" ===== Theme ===== {{{
let base16colorspace=256
set background=dark
colorscheme base16-solarized-dark

" " Override some defaults which I don't like.
hi Search ctermfg=21 guifg=#ffffff
hi pythonStatement ctermfg=5 guifg=#6c71c4
" " XXX: https://github.com/chriskempson/base16-vim/pull/132
hi MatchParen guifg=#002b36 guibg=#657b83 ctermfg=15 ctermbg=00
" }}}


" ===== Settings ===== {{{
set number
set smartcase
set ignorecase

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set title
set scrolloff=3
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db
set mouse=

set tags=tags;/     " Look up tree for tags
set t_Co=256        " Explicitly tell vim that the terminal has 256 colors
set ttimeout        " Time out on key codes
set ttimeoutlen=100 " Time out on key codes for 100ms
set display=lastline    " Display as much of the last line in a window as possible.
set complete-=i     " https://github.com/tpope/vim-sensible/issues/51

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

set fileformats+=mac
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

map ,u :source ~/.vimrc<CR>
imap jk <ESC>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l:nohlsearch<CR>:redraw!<CR>:nohlsearch<CR>

map g] :tjump <C-R><C-W><CR>
nmap <leader>x <Plug>CommentaryLine
xmap <leader>x <Plug>Commentary
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

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


" ===== Conditionals ===== {{{

" Add python path to path so that go to file (gf) works.
if has("python")
python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
endif

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


" ===== neocomplete ===== {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" }}}


" ===== neomake ===== {{{
if exists(":Neomake")
    autocmd! BufReadPost * Neomake
    autocmd! BufWritePost * Neomake
endif
let g:neomake_javascript_enabled_makers = ['eslint']
" }}}


" ===== python-mode ===== {{{
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_rope = 0
" }}}


" ===== vim-airline ===== {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
let g:airline#extensions#tabline#enabled = 1
" TODO: Tagbar is REALLY slow for large files.
let g:airline#extensions#tagbar#enabled = 0

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    if g:airline_theme == 'luna'
        for colors in values(a:palette.inactive)
            let colors[3] = 250
        endfor
    endif
endfunction
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
