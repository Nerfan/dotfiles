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
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
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
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" Place any and all vim-plug plugins here
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-bufferline'
if has("nvim")
    Plug 'Shougo/deoplete.nvim'
    Plug 'zchee/deoplete-jedi'
    Plug 'zchee/deoplete-clang'
    Plug 'Shougo/neoinclude.vim'
endif
Plug 'terryma/vim-multiple-cursors'
Plug 'justinmk/vim-syntax-extra'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim', {'on': 'Goyo' }
Plug 'scrooloose/syntastic'
" Any vim-plug plugins must come before this point
call plug#end()

"""""""""""""""""""""""""""
" GENERIC GLOBAL SETTINGS "
"""""""""""""""""""""""""""

set background=dark " Set colors to match a dark background
syntax on           " Syntax highlighting
set number          " Show line numbers
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set noincsearch		" Incremental search
set nohlsearch      " Don't highlight search matches
"set autowrite		" Automatically save before commands like :next and :make
set hidden	    	" Hide buffers when they are abandoned
set mouse-=a		" Disable mouse usage (all modes)
set encoding=utf-8  " Enable supprt for unicode characters
set clipboard=unnamedplus

" Sets up tabbing stuff
set expandtab       " Tab is spaces instead of a single tab character
set tabstop=4       " 4 spaces
set softtabstop=4
set shiftwidth=4    " Same
set autoindent      " Automatically indents lines according to previous indent
set smartindent     "

" Have Vim jump to the last position when
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins
if has("autocmd")
  filetype plugin indent on
endif

" PEP8 specifies a max line length of 79 characters, so the line should not be crossed
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
colorscheme gruvbox
hi clear CursorLine
hi CursorLineNr cterm=bold
set cursorline

" Stuff to make sure airline works
set laststatus=2                    " Always show status bar
set t_Co=256                        " Use 256 colors in terminal
set timeoutlen=500                  " Update mode quicker
let g:airline_powerline_fonts = 1   " Use powerline fonts
set noshowmode                      " The next three just remove a bunch of repeated info from the command line
set noruler
set noshowcmd
let g:airline_theme='gruvbox'       " Set airline theme

" Airline-Bufferline
let g:airline#extensions#bufferline#enabled = 1 " Bufferline (on statusbar)
let g:bufferline_echo = 0 " Don't have bufferline echo to the command line

" Airline-Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0 " configure whether or not to show buffers on the tabline
let g:airline#extensions#tabline#tab_min_count = 2 " configure the minimum number of tabs needed to show the tabline.
let g:airline#extensions#tabline#show_close_button = 0 " configure whether or not to show the close button

" Syntastic
let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_python_pylint_exec = '/usr/bin/pylint3'
let g:syntastic_c_checkers = ["gcc", "clang_check"]
let g:syntastic_c_gcc_args = "-std=c99 -Wall, -Wextra -pedantic"
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

""""""""""""""""
" KEY MAPPINGS "
""""""""""""""""
" Map Control-N to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>
" Capitalize the last word written or the word the cursor is currently on
inoremap <C-u> <Esc>viwUea
nnoremap <C-u> viwUe
" Insert a standard empty C-style for-loop
inoremap <C-f> for (int i = 0; i < ; i++) {<Esc>F;i
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
