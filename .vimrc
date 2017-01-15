" TODO: Some ruby/python plugins interfere with stock vim installations which
"       cause it to return 1.

filetype off

" == Configure pathogen (legacy)  ==================================== {{{
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" }}}

" == Configure NeoBundle ============================================= {{{
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

 " NOTE: Uncomment below when rid of pathogen.
 " set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/neobundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

  " == My Bundles  ================================================== {{{

  NeoBundle 'mileszs/ack.vim'
  NeoBundle 'rking/ag.vim'
  NeoBundle 'bling/vim-airline'
  NeoBundle 'chriskempson/base16-vim'
  NeoBundle 'tpope/vim-commentary'
  NeoBundle 'ctrlpvim/ctrlp.vim'
  NeoBundle 'chrisbra/csv.vim'
  NeoBundle 'editorconfig/editorconfig-vim'
  NeoBundle 'fatih/vim-go'
  NeoBundle 'mitsuhiko/vim-jinja'
  NeoBundle 'LustyJuggler'
  NeoBundle 'mustache/vim-mustache-handlebars'
  NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'jistr/vim-nerdtree-tabs'
  NeoBundle 'tpope/vim-rsi'
  NeoBundle 'saltstack/salt-vim'
  NeoBundle 'tpope/vim-surround'
  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'majutsushi/tagbar'
  NeoBundle 'smerrill/vcl-vim-plugin'

  " JavaScript-specific.
  NeoBundle 'lukaszkorecki/CoffeeTags'
  NeoBundle 'kchmck/vim-coffee-script'
  NeoBundleLazy 'pangloss/vim-javascript', {'autoload': {'filetypes': ['javascript']}}
  NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload': {'filetypes': ['javascript']}}
  NeoBundle 'mxw/vim-jsx'
  NeoBundleLazy 'marijnh/tern_for_vim', {
    \   'autoload': {
    \     'filetypes': ['javascript']
    \   },
    \   'build': {
    \     'unix': 'npm install',
    \   }
    \ }
  NeoBundleLazy 'facebook/vim-flow', {
    \    'autoload': {
    \        'filetypes': 'javascript'
    \    },
    \    'build': {
    \        'mac': 'npm install -g flow-bin',
    \        'unix': 'npm install -g flow-bin'
    \    }
    \ }

  " }}}

call neobundle#end()

" }}}

filetype plugin indent on

NeoBundleCheck

" == Appearance ====================================================== {{{

let base16colorspace=256
colorscheme base16-solarized
set background=dark
syntax on

" }}}

" == Settings ======================================================== {{{

set number          " Show line numbers
set smartcase       " Enable smart-case search
set incsearch       " Incremental search (vim-sensible)
set ignorecase      " Ignore case in search patterns.
set hlsearch        " Highlight search.

set autoindent      " Auto indent new lines (vim-sensible)
set expandtab       " Convert tabs to spaces.
set smarttab        " Enable smart tabs (vim-sensible) (NEW)
set shiftwidth=4    " Number of spaces to autoindent.
set softtabstop=4   " Number of spaces for soft tabs.
set tabstop=4       " Number of spaces for tabs.

set backspace=2     " More powerful backspacing. (vim-sensible)
set ruler           " Show line and cursor position. (vim-sensible)
set showcmd         " Show partial command in status line. (vim-sensible)
set laststatus=2    " Always display the statusline. (vim-sensible)
set title           " Show title in console title bar.
set scrolloff=3     " Show 3 lines while scrolling.

set wildmenu        " Turn on completion menu for commands (vim-sensible)
set tags=tags;/     " Look up tree for tags
set t_Co=256        " Explicitly tell vim that the terminal has 256 colors
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db

set ttimeout        " Time out on key codes
set ttimeoutlen=100 " Time out on key codes for 100ms
set display=lastline    " Display as much of the last line in a window as possible.
set complete-=i     " https://github.com/tpope/vim-sensible/issues/51

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j  " Delete comment character when joining commented lines
endif

set autoread        " Automatically reload file if changed and not modified. (vim-sensible)
set history=1000    " Increase history (vim-sensible)
set tabpagemax=50   " Allow more tabs to be opened from command line (vim-sensible)
set fileformats+=mac    " Add mac fileformat (vim-sensible)

" }}}

" == Keybindings ===================================================== {{{

set pastetoggle=<F2>
map <F1> :NERDTreeTabsToggle<CR>
map! <F1> <ESC>:NERDTreeTabsToggle<CR>a
map <F3> :nohlsearch<CR>
map! <F3> <ESC>:nohlsearch<CR>a
map <F4> :TagbarToggle<CR><C-w>l
map! <F4> <ESC>:TagbarToggle<CR><C-w>l
map <F5> oimport ipdb;ipdb.set_trace()<ESC>
map! <F5> <ESC>iimport ipdb;ipdb.set_trace()<CR>

imap jk <ESC>

map <C-h> <C-w>h
map <C-j> <C-w>j

map <C-k> <C-w>k
map <C-l> <C-w>l:nohlsearch<CR>:redraw!<CR>:nohlsearch<CR>

map ,u :source ~/.vimrc<CR>

map g] :tjump <C-R><C-W><CR>

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

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" }}}

" == Leaders ========================================================= {{{

nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>v V`]

nmap <leader>x <Plug>CommentaryLine
xmap <leader>x <Plug>Commentary

" }}}

" == Aliases ========================================================= {{{

command! -bang -nargs=* W w<bang> <args>
command! -bang -nargs=* Q q<bang> <args>
command! -bang -nargs=* Wq wq<bang> <args>
command! -bang -nargs=* WQ wq<bang> <args>

" }}}

" == Conditionals ==================================================== {{{

if has("autocmd")
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    autocmd FileType yaml setlocal sw=2 sts=2

    autocmd FileType py,python setlocal expandtab
    autocmd FileType html,css,php,js,javascript,py,python set autoindent
    autocmd BufNewFile,BufRead *.jinja set filetype=jinja
    autocmd BufNewFile,BufRead *.ctmpl set filetype=gohtmltmpl  " consul templates
endif " has("autocmd")

if has("gui_running")
    set t_kb=ctrl-vBACKSPACE
    fixdel

    set noantialias
    inoremap <C-Space> <C-X><C-O>

    " HACK: To detect MacVim.
    if has("transparency")
        set transp=2
        set guifont=Monaco:h10
        set guioptions=-T
        set guioptions=-M
    else
        set guifont=Inconsolata-dz\ Medium\ 9
        set guioptions=m
    endif
else
    inoremap <Nul> <C-x><C-o>
    " TODO: is this needed?
    syntax enable
endif

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

" Always make the directory of the file we're editing the working directory.
" (tip 64)
"function! CHANGE_CURR_DIR()
"    let _dir = expand("%:p:h")
"    if _dir !~ '^/tmp'
"        exec "cd %:p:h"
"    endif
"    unlet _dir
"endfunction

"autocmd BufEnter * call CHANGE_CURR_DIR()

" }}}


" == Plugin Configuration ============================================ {{{

" -- Airline -- {{{
" TODO: Switch to lightline if this gets too annoying to use.

let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerline'
let g:airline#extensions#tabline#enabled = 1
" Tagbar is REALLY slow for large files.
let g:airline#extensions#tagbar#enabled = 0

"  }}}

" -- Gist -- {{{

if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
    let g:gist_clip_command = 'xclip -selection clipboard'
endif

" }}}

" -- Syntastic -- {{{
let g:syntastic_check_on_open=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['go', 'javascript', 'php', 'puppet', 'ruby', 'sh'],
                           \ 'passive_filetypes': ['scala', 'java', 'scss']}

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['jsxhint']

" HACK: For scala development.  We should be able to build this dynamically
" from build.sbt or from sbt 'show dependency-classpath'
let g:syntastic_scala_options="-deprecation -cp \"$HOME/.ivy2/jars/*\""

let g:syntastic_puppet_puppetlint_args="--no-arrow_alignment-check --no-80chars-check --no-documentation-check"

let g:syntastic_objc_config_file='.clang_complete'
" TODO: WTF, why does clang completely fuck up?
"let g:syntastic_objc_compiler='clang'

" For angular.
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" For location list.
let g:syntastic_always_populate_loc_list=1

" }}}

" -- ctrlp -- {{{
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v(\/node_modules|\/vendor|\.git|\.hg|\.svn|\.egg|\.egg-info$)',
    \ 'file': '\v(\.sw[a-z]\|\.py[co]|\.egg|\.class)$',
    \ }
let g:ctrlp_user_command = 'ack -f %s'

" }}}

" -- tagbar -- {{{
let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

let g:tagbar_type_go = {
    \ 'ctagstype': 'go',
    \ 'kinds' : [
        \'p:package',
        \'f:function',
        \'v:variables',
        \'t:type',
        \'c:const'
    \]
\}

" }}}

" -- python-mode -- {{{
let g:pymode_folding = 0
let g:pymode_lint = 0
" }}}

" -- vim-go -- {{{
let g:go_fmt_command = "goimports"
" }}}

" -- vim-flow -- {{{
let g:flow#autoclose = 1
" }}}
