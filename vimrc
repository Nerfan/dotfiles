" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Enables true color in neovim
if has("nvim")
    set termguicolors
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

""""""""""""
" VIM-PLUG "
""""""""""""

" Auto-installs vim-plug if it's not already installed
if empty(glob('~/.local/share/nvim/site/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" Place any and all vim-plug plugins here
Plug 'morhetz/gruvbox'
Plug 'andrwb/vim-lapis256'
Plug 'sjl/badwolf'
Plug 'dikiaap/minimalist'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
if has("nvim")
    Plug 'Shougo/deoplete.nvim'
    Plug 'zchee/deoplete-jedi'
"    Plug 'zchee/deoplete-clang'
"    Plug 'Shougo/neoinclude.vim'
    Plug 'artur-shaik/vim-javacomplete2'
endif
Plug 'terryma/vim-multiple-cursors'
"Plug 'justinmk/vim-syntax-extra'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim', {'on': 'Goyo' }
"Plug 'scrooloose/syntastic'
Plug 'neomake/neomake'
" Any vim-plug plugins must come before this point
call plug#end()

"""""""""""""""""""""""""""
" GENERIC GLOBAL SETTINGS "
"""""""""""""""""""""""""""

set background=dark " Set colors to match a dark background
syntax on           " Syntax highlighting
set number          " Show line numbers
set relativenumber  " Show distance instead of absolute numbers
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set noincsearch		" Incremental search
set nohlsearch      " Don't highlight search matches
"set autowrite		" Automatically save before commands like :next and :make
set hidden	    	" Hide buffers when they are abandoned
set mouse=n 		" Enable mouse only in normal mode
set encoding=utf-8  " Enable supprt for unicode characters
set clipboard=unnamedplus

" Sets up tabbing stuff
set expandtab       " Tab is spaces instead of a single tab character
set tabstop=4       " Tabs are viewed as 4 spaced
set softtabstop=4   " Tabs are inserted as 4 spaces
set shiftwidth=4    " Auto tabbing uses 4 spaces
set autoindent      " Automatically indents lines according to previous indent
set smartindent     " Context sensitive indentation (e.g. Indent again after {)

" Have Vim jump to the last position when opening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins
if has("autocmd")
  filetype plugin indent on
endif

" PEP8 specifies a max line length of 79 characters, so don't hit the line
autocmd FileType python setlocal colorcolumn=80

" Automatically show trailing whitespace if not typing
autocmd BufWinEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufWinLeave * call clearmatches()
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=White guibg=red

"""""""""""""""""""
" PLUGIN SETTINGS "
"""""""""""""""""""

" Color options
" Set the colorscheme to gruvbox (all gruvbox options must come before
" colorscheme gruvbox)
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=0
colorscheme gruvbox
hi clear CursorLine
hi CursorLineNr cterm=bold
set cursorline
"hi Normal guibg=NONE ctermbg=NONE

" Stuff to make sure airline works
set laststatus=2                    " Always show status bar
set t_Co=256                        " Use 256 colors in terminal
set timeoutlen=500                  " Update mode quicker
let g:airline_powerline_fonts = 1   " Use powerline fonts
set noshowmode                      " The next three just remove a bunch of repeated info from the command line
set noruler
set noshowcmd
let g:airline_theme='gruvbox'       " Set airline theme

" Airline-Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1 " configure whether or not to show buffers on the tabline
let g:airline#extensions#tabline#buffer_nr_show = 1 " show the index of each buffer
let g:airline#extensions#tabline#tab_min_count = 2 " configure the minimum number of tabs needed to show the tabline.
let g:airline#extensions#tabline#show_close_button = 0 " configure whether or not to show the close button

" Show Neomake errors and warnings in airline
let g:airline#extensions#neomake#enabled = 1

" Run Neomake upon every write to a buffer
autocmd! BufWritePost * Neomake

hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#file#enable_buffer_path = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

""""""""""""""""
" KEY MAPPINGS "
""""""""""""""""
" Map Control-N to toggle NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
" Capitalize the last word written or the word the cursor is currently on
inoremap <C-u> <Esc>viwUea
nnoremap <C-u> viwUe
" Insert a standard empty C-style for-loop
inoremap <C-f> for (int i = 0; i < ; i++) {<CR>}<Esc>k$F;i
" Window management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
command NumberLines %s/^/\=printf('%3d ', line('.'))
" Neovim terminal
if has("nvim")
    tnoremap <Esc> <C-\><C-n>
endif
