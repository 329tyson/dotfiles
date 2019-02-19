" @wookayin's vimrc file
" https://dotfiles.wook.kr/vim/vimrc
"
" https://github.com/wookayin/dotfiles

scriptencoding utf-8

"""""""""""""""""""""""""""""""""""""""""
" 0. Load Plugin {{{
"""""""""""""""""""""""""""""""""""""""""

" All the vim plugins, powered by 'vim-plug', are
" listed up in the separate file 'plugins.vim'.
" It is for making this vimrc could also work out-of-box
" even if not managed by dotfiles.
if filereadable(expand("\~/.vim/plugins.vim"))
    source \~/.vim/plugins.vim
endif

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" }}}
"""""""""""""""""""""""""""""""""""""""""
" 1. General Settings {{{
"""""""""""""""""""""""""""""""""""""""""

syntax on
set nocompatible

if filereadable('/bin/zsh')
  set shell=/bin/zsh
endif

" use path '~/.vim' even on non-unix machine
set runtimepath+=~/.vim

" add ~/.local/bin to $PATH
let $PATH .= ":" . expand("\~/.local/bin")

" load plugins with pathogen
try
    runtime bundle/vim-pathogen/autoload/pathogen.vim
    call pathogen#infect()
catch
endtry

" basic displays
set number                  " show line numbers
set ruler

" input settings
set bs=indent,eol,start     " allow backspaces over everything
set autoindent
set smartindent
set pastetoggle=<F8>

set nowrap
set textwidth=0             " disable automatic line breaking
set cursorline

" tab settings
set tabstop=4
set shiftwidth=4
set softtabstop=4

" tab navigation
set showtabline=2           " always show tab pannel

set scrolloff=3

" search
set ignorecase              " case-insensitive by default
set smartcase               " case-sensitive if keyword contains both uppercase and lowercase
set incsearch
set hlsearch

if has('nvim')
  " live preview of substitute command, with a split window
  " @seealso http://vimcasts.org/episodes/neovim-eyecandy/
  set inccommand=split
endif

" use spaces for tabbing, by default
set expandtab

" listchars for whitespaces
set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<

" wildmenu settings
set wildmenu
set wildmode=list:longest,full
set wildignore=*.swp,*.swo,*.class

" status line
set laststatus=2            " show anytime
set noshowmode              " don't display mode, e.g. '-- INSERT --'
set showcmd


" native customized statusline, if airline is not available
" (this setting will be replaced afterwards by airline)
set statusline=%1*%{winnr()}\ %*%<\ %f\ %h%m%r%=%l,%c%V\ (%P)

" mouse behaviour
if has('mouse')
    set mouse=nvc
endif
if ! has('nvim')
    " vim only (not in neovim)
    set ttymouse=xterm2
endif


" encoding and line ending settings
if !has('nvim')
    set encoding=utf-8
endif
set fileencodings=utf-8,cp949,latin1
set fileformats=unix,dos

" split and autocomplete settings
set splitbelow                              " preview window at bottom
"set splitright
set completeopt=menuone,longest     " show preview and pop-up menu
"set completeopt=menuone,preview              " show preview and pop-up menu


" no fucking swap and backup files
set noswapfile
set nobackup

" miscellanious
set visualbell
set history=1000
set undolevels=1000
set lazyredraw              " no redrawing during macro execution

set mps+=<:>

" when launching files via quickfix, FZF, or something else,
" first switch to existing tab (if any) that contains the target buffer,
" or open a new buffer by splitting window in the current tab otherwise.
set switchbuf+=usetab,split

" diff: ignore whitespaces
set diffopt+=iwhite

" jump to the last position when reopening a file
if has("autocmd")
  let s:last_position_disable_filetypes = ['gitcommit']
  au BufReadPost * if index(s:last_position_disable_filetypes, &ft) < 0 && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
endif

" use strong encryption
if ! has('nvim')
    if v:version >= 800 || v:version == 704 && has('patch399')
        set cryptmethod=blowfish2 " Requires >= 7.4.399
    else
        set cryptmethod=blowfish
    endif
endif

" When opening http urls using netrw, follow 302 redirects
let g:netrw_http_cmd = 'curl -L -o'

" terminal mode (neovim)
if has('nvim')
  au TermOpen * setlocal nonumber norelativenumber
endif

" }}}
"""""""""""""""""""""""""""""""""""""""""
" 2. Key and Functional Mappings {{{
"""""""""""""""""""""""""""""""""""""""""

" the leader key
" (NOTE) leader key is mapped to vim-which-key, see sections below
let mapleader=","           " comma is the <Leader> key.
let maplocalleader=","      " comma : <LocalLeader>

inoremap <silent> <C-k> <ESC>:update<CR>

" navigation key mapping
map <silent> k gk
map <silent> j gj
sunmap k
sunmap j

nmap <up> gk
nmap <down> gj

inoremap <up> <c-\><c-o>gk
inoremap <down> <c-\><c-o>gj

noremap <C-F> <C-D>
noremap <C-B> <C-U>

" Ignore errornous input in Mac OS X
imap <D-space> <Nop>

" <Ctrl-Space> invokes <C-X><C-O> (omni-completion)
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

" window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" zoom and unzoom (like tmux) -- by 'vim-maximizer'
nnoremap <C-w>z :MaximizerToggle<CR>

" well...?
inoremap <C-C> <ESC>


" in terminal mode (neovim)
if has('nvim')
    " <C-\><C-n> is the key sequence for escaping form terminal mode
    " double <ESC> and double <C-\> also goes for escaping from terminal,
    " whereas single <ESC> would be directly passed inside the terminal.
    tnoremap <silent> <C-[><C-[> <C-\><C-n>
    tnoremap <silent> <C-\><C-\> <C-\><C-n>

    " Automatically enter insert mode when entering neovim terminal buffer
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermOpen * startinsert

    " terminal in a new tab or vsplit buffer
    command! -nargs=* Term :tabnew | :term <args>
    command! -nargs=* STerm :split | :term <args>

    " Mapping for <c-hjkl> in terminal mode
    " <c-h> might not work: see https://github.com/neovim/neovim/issues/2048
    tmap <C-h> <C-\><C-n><C-h>
    tmap <C-j> <C-\><C-n><C-j>
    tmap <C-k> <C-\><C-n><C-k>
    "tmap <C-l> <C-\><C-n><C-l>
    " TODO: <c-l> is for clear screen...?
endif

if has('nvim')
    " workaround for <c-h> mapping bug in neovim
    " @see https://github.com/neovim/neovim/issues/2048
    nmap <BS> <C-W>h
endif

" Buffer navigations
nnoremap [b  :bprevious<CR>
nnoremap ]b  :bnext<CR>

" Tab navigations
nnoremap [t  :tabprevious<CR>
nnoremap ]t  :tabnext<CR>
if has('nvim')
  tnoremap [t <C-\><C-n>:tabprevious<CR>
  tnoremap ]t <C-\><C-n>:tabnext<CR>
endif

nnoremap <C-t>     :tabnew<CR>

nnoremap <silent>   <C-S-tab> :tabprevious<CR>
nnoremap <silent>   <C-tab>   :tabnext<CR>
if has('nvim')
  tnoremap <silent> <C-S-tab> <C-\><C-n>:tabprevious<CR>
  tnoremap <silent> <C-tab>   <C-\><C-n>:tabnext<CR>
endif

 "Handy tab navigations: <Alt-num>
nnoremap 1 1gt
nnoremap 2 2gt
nnoremap 3 3gt
nnoremap 4 4gt
nnoremap 5 5gt
nnoremap 6 6gt
nnoremap 7 7gt
nnoremap 8 8gt
nnoremap 9 9gt

" Handy buffer navigations: <Alt-num>
"nnoremap <C-1> :1b<CR>
"nnoremap <C-2> :2b<CR>
"nnoremap <C-3> :3b<CR>
"nnoremap <C-4> :4b<CR>
"nnoremap <C-5> :5b<CR>
"nnoremap <C-6> :6b<CR>
"nnoremap <C-7> :7b<CR>
"nnoremap <C-8> :8b<CR>
"nnoremap <C-9> :9b<CR>

" do not exit from visual mode when shifting
" (gv : select the preivous area)
vnoremap < <gv
vnoremap > >gv

" Locations
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>

" -----------------------
" [F5] Make and Build {{{
" -----------------------
" use Make (vim-dispatch) or Neomake (neomake)
if has_key(g:plugs, 'neomake')
    " neomake; always use the bang version so that :copen can sync
    command! -nargs=0 -bang TheMake cexpr [] | Neomake!
    command! -nargs=0 TheCopen copen
else
    " vim-dispatch
    command! -nargs=0 -bang TheMake Make<bang>
    command! -nargs=0 TheCopen Copen
endif


" smartly dispatch according to filetype
function! s:run_make(bang)
    let l:silent_filetypes = ['tex', 'pandoc', 'lilypond']
    " (1) bang given, force background
    if a:bang == "!" | TheMake!
    " (2) for specified filetypes, use background
    elseif index(l:silent_filetypes, &filetype) >= 0 | TheMake!
    " (3) otherwise, make with foreground shown
    else | TheMake
    end
endfunction
command! -nargs=0 -bang RunMake call s:run_make("<bang>")

" A handy way to set makeprg.
command! -nargs=1 Makeprg let &g:makeprg="<args>" | echo "makeprg = <args>"

if has_key(g:plugs, 'vim-dispatch')
    " use vim-dispatch if exists

    " <F5>: run make, asynchronously or split windows (dispatch)
    map  <F5> <ESC>:w<CR>:RunMake<CR>
    imap <F5> <ESC>:w<CR>:RunMake<CR>a

    " <leader-F5>: run make with visible progress (split window in tmux)
    map  <leader><F5> <ESC>:w<CR>:RunMake!<CR>

else
    " otherwise, fallback to default make
    map <F5> <ESC>:w<CR>:make!<CR>
    imap <F5> <ESC>:w<CR>:make!<CR>a
endif

" Alternative to <F5>
map <leader>m <F5>

" }}}

" <F6>: show/close quickfix window (scroll bottom)
function! QuickfixToggle()
  let nr = winnr("$")
  :TheCopen
  let nr2 = winnr("$")
  if nr == nr2 | cclose | endif
endfunction
map  <silent> <F6> :call QuickfixToggle()<CR>
imap <silent> <F6> <ESC>:call QuickfixToggle()<CR>G:wincmd w<CR>a

" <leader>L: show/close location list window
function! LocListToggle()
  let nr = winnr("$")
  :lopen
  let nr2 = winnr("$")
  if nr == nr2 | lclose | endif
endfunction
map  <silent> <leader>L :call LocListToggle()<CR>

" [F4] Next Error [Shift+F4] Previous Error
map <F4> <ESC>:cn<CR>
map [26~ <ESC>:cp<CR>
map [1;2S <ESC>:cp<CR>
map [29~ <ESC>:cp<CR>

" [F2] save
imap <F2> <ESC>:w<CR>
map <F2> <ESC><ESC>:w<CR>

" save in the insert mode?
inoremap <C-S> <ESC>:update<CR>a

" Sudo Save (:Wsudo command)
command! Wsudo w !sudo tee % > /dev/null

" handy command-line mode
nnoremap ; :


" Useful leader key combinations {{{

" <leader><space> : turn off search highlight
nmap <silent> <leader><space> :noh<CR>

" Plugin ag.vim
" <leader>ag (or rg): Ag (search file contents)
nnoremap <leader>ag :Ag! -i ""<Left>
xnoremap <silent> <leader>ag y:Ag <C-R>"<CR>
nnoremap <leader>rg :Ag! -i ""<Left>
xnoremap <silent> <leader>rg y:Ag <C-R>"<CR>

if executable("rg")
  " Use ripgrep instead :)
  let g:ag_prg="rg --no-heading --vimgrep"
endif


" <leader>cd : switch to the directory of the current buffer
function! s:cd()
  cd %:p:h

  " if NERDTree is open, chdir NERDTree as well
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    :NERDTreeCWD | wincmd w
  endif
endfunction
nmap <silent> <leader>cd :call <SID>cd()<CR>

" <leader>R : screen sucks, redraw everything
function! Redraw()
  redraw!
  call s:auto_termguicolors()   " re-detect true colors
endfunction
nnoremap <leader>R :call Redraw()<CR>

" <leader>src : source ~/.vimrc
nnoremap <leader>src :source ~/.vimrc<CR>

" <leader>{y,x,p} : {yank,cut,paste} wrt the system clipboard
map <leader>y "*y
noremap <leader>x "*x
noremap <leader>p "*p

" <leader>w : save
nnoremap <leader>w :w!<CR>

" <leader>S : Strip trailing whitespaces
command! -nargs=0 Strip call StripTrailingWhitespaces()
nnoremap <leader>S :Strip<CR>

" <leader>df : diffthis
nnoremap <leader>df :diffthis<CR>

" Surround a word with quotes, single quotes, parens, brackets, braces, etc.
"   requires and powered by the plugin surround.vim :-)
" (Note) for visual blocks, use S command from surround.vim
map  <leader>s" ysiw"
map  <leader>s' ysiw'
map  <leader>s` ysiw`
map  <leader>s* ysiw*l
map  <leader>s_ ysiw_l
map  <leader>s~ ysiw~l
map  <leader>s$ ysiw$
map  <leader>s( ysiw(
map  <leader>s) ysiw)
map  <leader>s[ ysiw[
map  <leader>s] ysiw]
map  <leader>s{ ysiw{
map  <leader>s} ysiw}

" Zoom Tmux
noremap <silent> <leader>z :silent exec "!tmux resize-pane -Z"<CR>

" Prevent accidental <Ctrl-A> on Tmux
if !empty($TMUX)
    nnoremap <C-a> <nop>
    " To increase numbers, press <comma>, <c-a>, a ...?
    nnoremap <leader><C-a> <C-a>
endif

" }}}

" }}}
"""""""""""""""""""""""""""""""""""""""""
" 3. More Functions and Commands {{{
"""""""""""""""""""""""""""""""""""""""""

" ----------------------------------------------------------------------------
" <Leader>?/! : Google it / Feeling lucky
"   (code brought from @junegunn/dotfiles)
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
       \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf('open "https://www.google.com/search?%sq=%s"',
                   \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <leader>? :call <SID>goog(expand("<cword>"), 0)<cr>
nnoremap <leader>! :call <SID>goog(expand("<cword>"), 1)<cr>
xnoremap <leader>? "gy:call <SID>goog(@g, 0)<cr>gv
xnoremap <leader>! "gy:call <SID>goog(@g, 1)<cr>gv

" }}}
"""""""""""""""""""""""""""""""""""""""""
" 4. Appearance (e.g. Colors, Syntax) {{{
"""""""""""""""""""""""""""""""""""""""""

" color settings
" @see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
set t_Co=256                 " use 256 color
set bg=dark

if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" 24-bit true color: neovim 0.1.5+ / vim 7.4.1799+
" enable ONLY if TERM is set valid and it is NOT under mosh
function! s:is_mosh()
  let output = system("is_mosh -v")
  if v:shell_error
    return 0
  endif
  return !empty(l:output)
endfunction

function! s:auto_termguicolors()
  if !(has("termguicolors"))
    return
  endif

  if (&term == 'xterm-256color' || &term == 'nvim') && !s:is_mosh()
    set termguicolors
  else
    set notermguicolors
  endif
endfunction
call s:auto_termguicolors()


" apply base theme
silent! colorscheme xoria256

" airline theme: status line and tab line
if has("termguicolors") && &termguicolors
  let g:airline_theme='deus'
else
  let g:airline_theme='bubblegum'
endif


" override more customized colors
highlight StatusLine    ctermfg=LightGreen
highlight ColorColumn   ctermbg=52 guibg=#5f0000

highlight LineNr        ctermfg=248 ctermbg=233 guifg=#a8a8a8 guibg=#121212
highlight SignColumn    ctermfg=248 ctermbg=233 guifg=#a8a8a8 guibg=#121212

highlight Normal        ctermfg=255 guifg=white
highlight Comment       ctermfg=035 guifg=#38B04A
highlight Constant      ctermfg=204 guifg=#ff5f87
highlight PreProc       ctermfg=219 guifg=#ffafff
highlight SpecialKey    ctermfg=242 guifg=#666666

" colors for gui/24bit mode {{
" DiffAdd - inserted lines (dark green)
highlight DiffAdd       guibg=#103a05 guifg=NONE
" DiffDelete - deleted/filler lines (gray 246)
highlight DiffDelete    guibg=#949494
" DiffChange - changed lines (dark red)
highlight DiffChange    guibg=#471515 guifg=NONE
" DiffChange - changed 'text'(brighter red)
highlight DiffText      guibg=#721b1b guifg=NONE
" }}


" no underline, current cursor line
highlight CursorLine    cterm=none

" show cursorline for active window only
augroup NrHighlight
    autocmd!
    autocmd BufEnter * setlocal cursorline
    autocmd BufLeave * setlocal nocursorline
augroup END

" IDE settings
filetype plugin on
filetype indent on

" filetype detections
au BufRead,BufNewFile /etc/nginx/* if &ft == '' | setfiletype nginx | endif
au BufRead,BufNewFile *.prototxt if &ft == '' | setfiletype yaml | endif

autocmd FileType git setlocal foldlevel=1

" remove trailing whitespaces on save
fun! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,javascript,html,ruby,python,pandoc
    \ autocmd BufWritePre <buffer> :call StripTrailingWhitespaces()

" highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd FileType GV highlight clear ExtraWhitespace

match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Unset paste when leaving insert mode
autocmd InsertLeave * silent! set nopaste

" better popup menu colors (instead of dark black)
highlight Pmenu ctermfg=black ctermbg=yellow guifg=black guibg=#ffec99
highlight PmenuSel ctermfg=red ctermbg=white guifg=red guibg=white gui=bold

" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
function! ShowSyntaxGroup()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction

noremap <leader>syn :call ShowSyntaxGroup()<cr>

" }}}
"""""""""""""""""""""""""""""""""""""""""
" 5. GUI Options {{{
"""""""""""""""""""""""""""""""""""""""""

" gui settings
if has("gui_running")

    if has("unix")
        let s:uname = substitute(system("uname -s"), '\n', '', '')
    endif

    if has("gui_win32")
        language mes en         " use english messages (korean characters broken)
        set langmenu=none       " use english context menus (korean characters broken)
        set guioptions-=T       " exclude toolbar
        set guioptions-=m       " exclude menubar

        " font setting for windows
        set guifont=Consolas:h11:cANSI
        set guifontwide=GulimChe:h12:cDEFAULT

    elseif has("gui_gtk2")
        " font setting for Ubuntu linux (GTK)
        set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12

    elseif has("unix") && s:uname == "Darwin"
        " font setting for Mac OS X (Darwin)
        set guifont=Monaco\ for\ Powerline:h12
        set guifontwide=Apple\ SD\ Gothic\ Neo\ UltraLight:h12
    endif

endif


" }}}
"""""""""""""""""""""""""""""""""""""""""
" 6. Plugin Settings {{{
"""""""""""""""""""""""""""""""""""""""""

" ----------------------------------------------------------------
" vim-localvimrc {{{

" store and restore all decisions on whether to load lvimrc
let g:localvimrc_persistent = 2

" ---------------------------------------------------------------- }}}
" vim-polyglot {{{

" in favor of python-mode and vimtex ...
let g:polyglot_disabled = ['python', 'latex']

" ---------------------------------------------------------------- }}}
" vim-startify {{{

let g:startify_bookmarks = [
    \ '~/.vim/vimrc',
    \ '~/.vim/plugins.vim',
    \ ]

let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ $VIMRUNTIME .'/doc',
    \ 'plugged/.*/doc',
    \ 'bundle/.*/doc',
    \ ]
" ---------------------------------------------------------------- }}}
" vim-emoji {{{

" replace emoji in selected lines
" (snippet brought from @junegunn/dotfiles)
function! s:replace_emojis() range
    for lnum in range(a:firstline, a:lastline)
        let line = getline(lnum)
        let subs = substitute(line,
                    \ ':\([^:]\+\):', '\=emoji#for(submatch(1), submatch(0))', 'g')
        if line != subs
            call setline(lnum, subs)
        endif
    endfor
    redraw!
endfunction

command! -range EmojiReplace <line1>,<line2>call s:replace_emojis()
xnoremap <leader>emoji :Emoji<CR>

" ---------------------------------------------------------------- }}}
" vim-asterisk (enhanced *) {{{

"' Use z (stay) behavior as default
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

" Keep cursor position across matches
let g:asterisk#keeppos = 1

" ---------------------------------------------------------------- }}}
" incsearch {{{

" incsearch.vim
if has_key(g:plugs, 'incsearch.vim')
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
endif

" incsearch-fuzzy.vim
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" ---------------------------------------------------------------- }}}
" vim-highlightedyank {{{
if ! has("nvim") && has_key(g:plugs, 'vim-highlightedyank')
    map y <Plug>(highlightedyank)
endif

"hi HighlightedyankRegion cterm=reverse gui=reverse
let g:highlightedyank_highlight_duration = 1000

" ---------------------------------------------------------------- }}}
" vim-quickhl {{{

nmap <leader>* <Plug>(quickhl-manual-this)
xmap <leader>* <Plug>(quickhl-manual-this)
nmap <leader>8 <Plug>(quickhl-manual-reset)
xmap <leader>8 <Plug>(quickhl-manual-reset)

" ---------------------------------------------------------------- }}}
" vim-highlightedundo {{{

if has_key(g:plugs, 'vim-highlightedundo')
  nmap u     <Plug>(highlightedundo-undo)
  nmap <C-r> <Plug>(highlightedundo-redo)
  nmap U     <Plug>(highlightedundo-Undo)
  nmap g-    <Plug>(highlightedundo-gminus)
  nmap g+    <Plug>(highlightedundo-gplus)

  let g:highlightedundo#highlight_duration_delete = 500
  let g:highlightedundo#highlight_duration_add = 700
endif

" ---------------------------------------------------------------- }}}
" vim-which-key {{{

" which-key buffer will appear vertically on the right
let g:which_key_vertical = 1

" Make timeout delay to be 300ms (before popup appears), default is 1000ms
set timeoutlen=300

" Remap <leader> key to vim-which-key version.
" The following mapping assumes <leader> key is ',' (comma)
if has_key(g:plugs, 'vim-which-key')
  nnoremap <silent> <leader> :<c-u>WhichKey ','<CR>
endif

" ---------------------------------------------------------------- }}}
" editorconfig {{{

let g:EditorConfig_core_mode = 'python_external'
"let g:EditorConfig_core_mode = 'external_command'


" ---------------------------------------------------------------- }}}
" Airline {{{
" Note: for airline theme, see the 'appearance' section

" use airline, with powerline-ish theme
let g:airline_powerline_fonts=1

" enable tabline feature
let g:airline#extensions#tabline#enabled = 1

" Display buffers (like tabs) in the tabline
" if there is only one tab
let g:airline#extensions#tabline#show_buffers = 1

" suppress mixed-indent warning for javadoc-like comments (/** */)
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" ---------------------------------------------------------------- }}}
" Neomake {{{

" so that ':Neomake clean' invokes 'make clean'
let g:neomake_clean_maker = { 'exe': 'make', 'args': ['clean'] }

" General hook/callback on starting and finishing jobs {
function! s:OnNeomakeStart(context)
  " what will we do?
endfunction

function! s:OnNeomakeFinished(context)
  let l:context = g:neomake_hook_context

  " If there is any failed job (non-zero exit code), notify it.
  let l:failure_message = ""
  for job in l:context['finished_jobs']
    if l:job['exit_code'] != 0
      let l:failure_message = printf("%s%s ", l:failure_message, l:job['as_string']())
    endif
  endfor
  if ! empty(l:failure_message)
    echom "Job Finished, FAIL: " . l:failure_message
    copen | wincmd p   " copen, but not move to the quickfix window
  else
    echom "Job Finished, Success."
  endif
endfunction

augroup neomake_hooks_common
  au!
  autocmd User NeomakeJobInit  call s:OnNeomakeStart(g:neomake_hook_context)
  autocmd User NeomakeFinished call s:OnNeomakeFinished(g:neomake_hook_context)
augroup END
" }


" ---------------------------------------------------------------- }}}
" FZF {{{

" Inside vim, set environment variable FZF_DEFAULT_COMMAND
" so that it can list the files by 'git ls-files' or 'ag'.
if executable("ag")
    "let $FZF_DEFAULT_COMMAND = '(git ls-files ":/" || ag -l -g "") | LC_COLLATE=C sort | uniq  2> /dev/null'
    let $FZF_DEFAULT_COMMAND = 'ag -l -g "" 2> /dev/null'
endif

" Customize built-in commands of 'vim-fzf' (overriden by commands here) {{{
" For full list, @see https://github.com/junegunn/fzf.vim/blob/master/plugin/fzf.vim#L42

" :GFiles (with preview), :GFiles? (git diff + preview)
command! -bang -nargs=? GFiles     call fzf#vim#gitfiles(<q-args>, <q-args> != '?' ? (
      \ <bang>0 ? fzf#vim#with_preview('up:90%')
      \         : fzf#vim#with_preview('right:50%', '?')
      \) : <bang>0
      \)
" }}}

" :F is a shortcut for :GFiles or :FZF
function! s:fzf_smart()
    let l:git_dir = fugitive#extract_git_dir(expand('%:p'))
    " in a git repo, invoke :GFiles (plus untracked files)
    if ! empty(l:git_dir) | GFiles -c -o --exclude-standard
    " not in git repo, invoke :FZF by fallback
    else | FZF
    endif
endfunction
command! -nargs=0 F call s:fzf_smart()

" Invoke F (FZF) Using Ctrl-P
"nmap <C-P> :F<CR>
nmap <C-P> :GitFiles<CR>

" insert mode completion
imap <c-x><c-k>   <plug>(fzf-complete-word)


" custom commands using fzf
" -------------------------

" :Rg --- Easily grep
" brought from https://github.com/junegunn/fzf.vim
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -i --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \ <bang>0)

" :Def, Rgdef -- Easily find definition/declaration (requires ripgrep)
" e.g. :Def class, :Def def, :Def myfunc, :Def class MyClass
command! -bang -nargs=* Rgdef   call s:fzf_rgdef(<q-args>, <bang>0)
command! -bang -nargs=* Def     call s:fzf_rgdef(<q-args>, <bang>0)

function! s:fzf_rgdef(args, bang0)
    " TODO: currently, only python is supported.
    let l:rgdef_type = '--type "py"'
    let l:rgdef_prefix = '^\s*(def|class)'
    let l:rgdef_pattern = l:rgdef_prefix.' \w*'.a:args.'\w*'

    " if the query itself starts with prefix patterns, let itself be the regex pattern
    if a:args =~ ('\v'.l:rgdef_prefix.'($|\s+)')
      let l:rgdef_pattern = '^\s*'.a:args
    endif

    call fzf#vim#grep(
  \   'rg -i --column --line-number --no-heading --color=always '.l:rgdef_type.' '.shellescape(l:rgdef_pattern), 1,
  \   a:bang0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \ a:bang0)
endfunction



" :Z -- cd to recent working directories using fasd
command! -nargs=* Z call fzf#run
            \({
            \ 'source':  printf('fasd -Rdl "%s"',
            \                   escape(empty(<q-args>) ? '' : <q-args>, '"\')),
            \ 'options': '-1 -0 --no-sort +m',
            \ 'down':    '~33%',
            \ 'sink':    'NERDTree'
            \})

" :Plugs -- list all vim plugins and open the directory of the selected
command! -nargs=* Plugs call fzf#run
            \({
            \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home . "/" . v:val'),
            \ 'options': '--delimiter "/" --nth -1' . printf(' --query "%s"', <q-args>),
            \ 'down':    '~33%',
            \ 'sink':    'NERDTree'
            \})

" Leader key mappings for vim-fzf commands

" List all open buffers
nnoremap <leader>FB :Buffers<CR>
nnoremap <leader>B :Buffers<CR>
" :B goes to :Buffers
command! B Buffers
" Tags in the current buffer (see tagbar)
nnoremap <leader>FT :BTags<CR>
" Git commits
nnoremap <leader>FG :Commits<CR>
" History (recently opened files)
nnoremap <leader>FH :History<CR>
nnoremap <leader>H :History<CR>
" :GS -> Git status (open modified file, etc.)
command! GS GFiles?
" :H goes to :History
command! H History

" ---------------------------------------------------------------- }}}
" Dash {{{

" ----------------------------------------------------------------------------
" <Leader>/ : Launch Dash on the words on cursor or in block
" ----------------------------------------------------------------------------
nnoremap <leader>/ :Dash <cword><cr>
xnoremap <leader>/ "gy:Dash <c-r>g<cr>gv

" ---------------------------------------------------------------- }}}
" SuperTab {{{

" Use 'omnicomplete' as the default completion type.
" It may fallback to default keyword completion (<C-P>).
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

" sometimes we may want to insert tabs or spaces for indentation.
" no tab completion at the start of line or after whitespace.
let g:SuperTabNoCompleteAfter = ['^', '\s']

" ---------------------------------------------------------------- }}}
" NerdTree {{{

" change CWD when the NERDtree is first loaded to the directory initialized in
" (e.g. change CWD to the directory hitted by CtrlPZ)
let g:NERDTreeChDirMode = 1

" <Leader>N toggles NERDTree (across tab)
map <Leader>N <plug>NERDTreeTabsToggle<CR>

" Startup Options (do NOT show automatically)
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup = 0

" filter out some files, by extension
let NERDTreeIgnore = ['\.pyc$', '\.class$', '\.o$']

" ---------------------------------------------------------------- }}}
" Voom {{{

let g:voom_ft_modes = {'pandoc': 'markdown', 'tex': 'latex'}

nnoremap <leader>V :VoomToggle<CR>

" ---------------------------------------------------------------- }}}
" Easymotion {{{

" Trigger <,f> to launch easymotion global jump
nmap <leader>f <Plug>(easymotion-s)

" backward, forward search may mapped to easymotion.
"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)

" Jump to first match, by Enter or Space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1

" ---------------------------------------------------------------- }}}
" vim-easy-align {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ---------------------------------------------------------------- }}}
" UltiSnips {{{
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" ---------------------------------------------------------------- }}}
" vim-pandoc {{{

" disable automatic folding
let g:pandoc#modules#disabled = ["folding"]

" disable conceals
let g:pandoc#syntax#conceal#use = 0

" disable spell check
let g:pandoc#spell#enabled = 0

" ---------------------------------------------------------------- }}}
" vim-javacomplete2 {{{
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" ---------------------------------------------------------------- }}}
" echodoc.vim {{{
let g:echodoc#enable_at_startup = 1

" ---------------------------------------------------------------- }}}
" deoplete.nvim {{{
let g:deoplete#enable_at_startup = 1


" Register some default omnicomplete functions/patterns
" to automatically trigger in deoplete {{
let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})

let g:deoplete#omni#functions.tex = ['vimtex#complete#omnifunc']
let g:deoplete#omni#input_patterns.tex =
      \ '(?:'
      \ . '\\\w*'
      \ . ')'

let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
let g:deoplete#omni#input_patterns.lua = '\w+|[^. *\t][.:]\w*'

" }}

" ---------------------------------------------------------------- }}}
" Lua {{{
" https://github.com/xolox/vim-lua-ftplugin
"
" See also:
" https://github.com/Shougo/deoplete.nvim/issues/458      compatibility with deoplete
" https://github.com/xolox/vim-lua-ftplugin/issues/40     if not working with Torch

let g:lua_check_syntax = 1

let g:lua_complete_omni = 1

if has_key(g:plugs, 'deoplete.nvim')
  let g:lua_complete_dynamic = 0    " deoplete will take care of this instead
endif

let g:lua_define_completion_mappings = 0


" ---------------------------------------------------------------- }}}
" semshi {{{


" ---------------------------------------------------------------- }}}
" ALE {{{

" Specify linters.
" You may find the configuration file for each linter engine useful.
"  (e.g. ~/.pylintrc for pylint)
let g:ale_linters = {
      \ 'python': ['pylint', 'mypy', 'pycodestyle'],
      \}

let g:ale_type_map = {
      \ 'pycodestyle' : {'ES' : 'WS', 'E': 'W'}
      \}

" linter-specific settings
let g:ale_python_mypy_options = '--ignore-missing-imports'

" Also show which linter is showing the message
let g:ale_echo_msg_format = '[%linter%] %code: %%s'

" better error/warning sign
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
hi ALEErrorSign    gui=bold guifg=#e6645f ctermfg=167
hi ALEWarningSign  gui=bold guifg=#b1b14d ctermfg=143

" no highlight (underline) on detected errors/warnings
let g:ale_set_highlights = 0

" Show the number of errors/warnings in the airline statusbar
let g:airline#extensions#ale#enabled = 1

" Suppress a warning for the conflict with Neomake
" Neomake is used for job execution, not a lint engine, so it would
" be fine.
let g:ale_emit_conflict_warnings = 0

" ---------------------------------------------------------------- }}}
" python (pymode, jedi) {{{

" heavenshell/vim-pydocstring
" Change default keymapping to <C-_> (default is <C-l>)
nmap <silent> <C-_> <Plug>(pydocstring)

" disable code folding by default
let g:pymode_folding = 0

" disable rope (terribly slow), in favor of jedi-vim
let g:pymode_rope = 0

" prefer jedi's <leader>r (rename), instead of run
" however, jedi resets all the highlight :( - why?
let g:pymode_run = 0

" Use ipython pdb for inserting breakpoints
" one might need to run 'pip install ipdb'
let g:pymode_breakpoint_cmd = 'import ipdb; ipdb.set_trace()'

" lint (code checking):
" disable in favor of ALE, but only if pylint/pycodestyle exists
let s:py_linters_exists = executable("pylint") || executable("pycodestyle")
if has_key(g:plugs, 'ale') && s:py_linters_exists
    let g:pymode_lint = 0
endif

" Check code on every save (not on the fly)
let g:pymode_lint_on_write = 1
let g:pymode_lint_unmodified = 1

" Do NOT open quickfix window when any pymode_lint errors have been found
let g:pymode_lint_cwindow = 0

" Skip some errors and warnings
" see also ~/.config/pycodestyle (for ALE)
"  E401 : multiple imports on one line
"  E501 : line too long
let g:pymode_lint_ignore = ["E401", "E501"]


" For neovim or vim8 (completor.vim),
" disable jedi's autocompletion behavior but enable all the other features (e.g. goto, or refactoring)
" The autocompletion is supported by deoplete-jedi or completor.vim.
if has_key(g:plugs, 'deoplete-jedi') || has_key(g:plugs, 'completor.vim')
"if has('nvim') || v:version >= 800
    " @see https://github.com/zchee/deoplete-jedi/issues/35
    let g:jedi#completions_enabled = 0
endif

" Make jedi's completeopt not to include 'longest',
" to prevent underscore prefix auto-completion (e.g. self.__)
" @see jedi-vim issues #429
let g:jedi#auto_vim_configuration = 0

" Do not automatically add the 'import' statement for 'from ...'
let g:jedi#smart_auto_mappings = 0

" Turn off call signatures temporarily, due to an annoying bug
" @see https://github.com/davidhalter/jedi-vim/issues/257
let g:jedi#show_call_signatures = 0

" jedi-vim opens buffer in the current tab (rather than a new tab)
" when goto (e.g. goto definition) is performed
let g:jedi#use_tabs_not_buffers = 0

" window splits to open with; for now, it is disabled
"let g:jedi#use_splits_not_buffers = 'bottom'
"
"let g:jedi#popup_on_dot = 0

" ---------------------------------------------------------------- }}}
" deoplete-clang {{{

if filereadable('/usr/lib/llvm-3.4/lib/libclang.so')
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.4/lib/libclang.so'
elseif filereadable('/Library/Developer/CommandLineTools/usr/lib/libclang.dylib')
    let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
endif


if isdirectory('/usr/include/clang')
    let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
elseif isdirectory('/Library/Developer/CommandLineTools/usr/lib/clang/')
    let g:deoplete#sources#clang#clang_header = '/Library/Developer/CommandLineTools/usr/lib/clang/'
endif

" ---------------------------------------------------------------- }}}
" LaTeX {{{

let g:LatexBox_Folding = 1

" suppress version warning
let g:vimtex_disable_version_warning = 1

let g:vimtex_mappings_enabled = 1

" Disable callback feature if vim lacks feature +clientserver
if ! (has('clientserver') || has('nvim'))
    let g:vimtex_latexmk_callback = 0

    " see https://github.com/lervag/vimtex/issues/507
    let g:vimtex_compiler_latexmk = {'callback' : 0}
endif

" in macOS, use Skim as the default LaTeX PDF viewer (for vimtex)
" for :Vimtexview, move Skim's position to where the cursor currently points to.
if has('mac')
    let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '-r -g @line @pdf @tex'
endif

" ---------------------------------------------------------------- }}}
" fugitive {{{

" key mappings
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gD :Gvdiff HEAD<CR>
nnoremap <leader>gs :Gstatus<CR>:20wincmd +<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gb :Gblame -w<CR>:vertical resize 10<CR>
nnoremap <leader>gci :Gcommit --verbose<CR>
nnoremap <leader>gcA :Gcommit --amend --verbose<CR>

" on commit, type 'cA' to enter in amend mode
au FileType gitcommit nnoremap <buffer> <silent>
            \ cA :bd<CR>:<C-U>Gcommit --verbose --amend<CR>

" ---------------------------------------------------------------- }}}
" gitgutter {{{

" another alias for adding or staging hunk (similar as <leader>ga)
nmap <leader>ha  <Plug>GitGutterStageHunk

nmap <leader>hh  :GitGutterLineHighlightsToggle<CR>

" ---------------------------------------------------------------- }}}
" gundo key mappings and options {{{
let g:gundo_right = 1   " show at right
nnoremap <leader>G :GundoToggle<CR>

" ---------------------------------------------------------------- }}}
" tagbar key mappings {{{
nnoremap <leader>T :TagbarToggle<CR>

" ---------------------------------------------------------------- }}}

" }}}
"""""""""""""""""""""""""""""""""""""""""
" Extra Settings {{{
"""""""""""""""""""""""""""""""""""""""""

" Use local vimrc if available
if filereadable(expand("\~/.vimrc.local"))
    source \~/.vimrc.local
endif

" }}}

" vim: set ts=2 sts=2 sw=2:
" custom vim settings
let g:airline_theme='jellybeans'
:colorscheme jellybeans
autocmd BufRead *.py setlocal colorcolumn=0
nnoremap <leader>q :qa<CR>
nnoremap <leader>wq :wqa<CR>
" <C-r><C-w> pastes word with cursor-on
nnoremap <leader>s :%s/\<<C-r><C-w>\>/
nnoremap <leader>vs :%s/\%V
nnoremap <leader>bd :bd<CR>
command Diff execute 'w !git diff --no-index % -'
