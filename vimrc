" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Everything for vundle
set nocompatible
filetype off
set rtp+=/etc/vim/bundle/vundle
call vundle#begin('/etc/vim/bundle')
" Place any and all vundle plugins here
Plugin 'gmarik/vundle'
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-bufferline'
" And Vundle plugins must come before this point
call vundle#end('/etc/vim/bundle')

" Set the colorscheme to gruvbox
colorscheme gruvbox

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set relativenumber             " Show line numbers
set number
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
set encoding=utf-8     " Enable supprt for unicode characters

" Sets up tabbing stuff
set expandtab       " Tab is spaces instead of a single tab character
set tabstop=4       " 4 spaces
set softtabstop=4
set shiftwidth=4    " Same
set autoindent      " Automatically indents lines according to previous indent
set smartindent     "

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Stuff to make sure airline works
set laststatus=2 " Always show status bar
set t_Co=256     " Use 256 colors in terminal
set timeoutlen=50 " Update mode quicker
let g:airline_powerline_fonts = 1 "Use powerline fonts
set noshowmode  " The next three just remove a bunch of repeated info from the command line
set noruler
set noshowcmd
let g:airline_theme='gruvbox'  " Use terminal colors for Airine

" Airline-Bufferline
let g:airline#extensions#bufferline#enabled = 1 " Bufferline (on statusbar)
let g:bufferline_echo = 0 " Don't have bufferline echo to the command line

" Airline-Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0 " configure whether or not to show buffers on the tabline
let g:airline#extensions#tabline#tab_min_count = 2 " configure the minimum number of tabs needed to show the tabline.
let g:airline#extensions#tabline#show_close_button = 0 " configure whether or not to show the close button

hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

map <C-n> :NERDTreeToggle<CR>
