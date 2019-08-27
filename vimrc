""" NVim Config by Mike Hanling


""""""""""""""""""""""""""
""" Vundle Requirements"""
""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree' 
Plugin 'junegunn/fzf' 
Plugin 'junegunn/fzf.vim' 
Plugin 'scrooloose/nerdcommenter' 
Plugin 'itchyny/lightline.vim' 
Plugin 'benmills/vimux'
Plugin 'dylanaraps/wal.vim'
"Plugin 'tpope/vim-fugitive'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""
"""General Settings"""
""""""""""""""""""""""
let mapleader=','

syntax enable

set number
set relativenumber
set autoread
set incsearch
set ignorecase
set smartcase
set magic
set autoindent
set showmatch
set wildmenu
set wildmode=list:longest
set title
set noexpandtab
set smarttab
set tabstop=3
set softtabstop=3
set shiftwidth=3
set shiftround
set backspace=indent,eol,start
set tw=80
highlight Comment cterm=italic term=italic gui=italic

"colorscheme industry
colorscheme wal

set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

"Remap CAPS to ESC - must have xorg-xmodmap package installed
au VimEnter * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

"Change scrolling to scroll by 3 as default
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

"Use System Clipboard with normal controls
vnoremap <C-c> "*y :let @+=@*<CR>
nnoremap <C-p> "*gP<CR>

"Map :NERDTree 
nnoremap <leader>nt :NERDTreeToggle<CR>

"Map :Files 
nnoremap <leader>f :Files<CR>

"Defines a marker for making jump points in future commands
inoremap <Tab><Space> <Esc>:set<Space>nohlsearch<CR>/[<.*>]<CR>ca]

"Open files to line that I left it on
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd Filetype c inoremap ;f <Esc>m`i[<returnType>]<Space>[<functionName>]([<args>])<Space>{<CR><CR>[<body>]<CR><CR><Backspace>return[<>];<CR><CR>}<CR><CR>[<>]<Esc>``i

autocmd BufWritePost *.tex :!pdflatex %
