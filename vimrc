" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Ensure that the rtp is set up correctly (esp. for nvim)
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

""""""""""""
" VIM-PLUG "
""""""""""""

" Function for markdown-composer
function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction

" Auto-installs vim-plug if it's not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" Place any and all vim-plug plugins here
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
if has("nvim")
    Plug 'Shougo/deoplete.nvim'
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh',}
endif
Plug 'terryma/vim-multiple-cursors'
"Plug 'justinmk/vim-syntax-extra'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim', {'on': 'Goyo' }
Plug 'junegunn/limelight.vim', {'on': 'Limelight' }
Plug 'neomake/neomake'
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" Any vim-plug plugins must come before this point
call plug#end()

"""""""""""""""""""""""""""
" GENERIC GLOBAL SETTINGS "
"""""""""""""""""""""""""""

" Enables true color if available
if has("termguicolors")
    set termguicolors
endif
set background=dark " Set colors to match a dark background
syntax on           " Syntax highlighting
set number          " Show line numbers
set relativenumber  " Show distance instead of absolute numbers
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set noincsearch		" Incremental search
set nohlsearch      " Don't highlight search matches
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

autocmd BufNewFile,BufRead *.e set filetype=c

" PEP8 specifies a max line length of 79 characters
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
let g:airline#extensions#tabline#fnamemod = ':t' " Only show the filename, not the path

" Show Neomake errors and warnings in airline
let g:airline#extensions#neomake#enabled = 1

" Run Neomake upon every write to a buffer
autocmd! BufWritePost * Neomake

hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

" Neovim plugins (Deoplete, LanguageClient)
if has("nvim")
    " Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#omni_patterns = {}
    let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
    let g:deoplete#file#enable_buffer_path = 1
	call deoplete#custom#source("_", "matchers", ["matcher_full_fuzzy"])
    " deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"
    " Close preview window when completion is done
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    " <CR>: close popup and save indent.
    " Enter no longer autocompletes, but it does line break if the menu is open
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return deoplete#smart_close_popup() . "\<CR>"
    endfunction

    " LanguageClient
    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ }
    augroup LC_Bindings
        autocmd!
        autocmd User LanguageClientStarted nnoremap <silent> <C-k> :call LanguageClient_textDocument_hover()<CR>
        autocmd User LanguageClientStarted nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    augroup END
    command Symbols call LanguageClient_textDocument_documentSymbol()
    command Refs call LanguageClient_textDocument_references()
    command Rename call LanguageClient_textDocument_rename()
endif

" markdown composer
let g:markdown_composer_open_browser = 0
let g:markdown_composer_browser='qutebrowser --backend webengine --target window'

" netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0

""""""""""""""""
" KEY MAPPINGS "
""""""""""""""""
" Map Control-N to toggle NERDTree
nnoremap <C-t> :Explore<CR>
" Capitalize the last word written or the word the cursor is currently on
inoremap <C-u> <Esc>viwUea
nnoremap <C-u> viwUe
" Insert a standard empty C-style for-loop
inoremap <C-f> for (int i = 0; i < ; i++) {<CR>}<Esc>k$F;i
" zz fixes to the first found spelling
nnoremap zz 1z=
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
