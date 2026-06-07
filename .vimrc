" ~/.vimrc
" Basic Vim configuration

" ── General ───────────────────────────────────────────────────────────────────
set nocompatible            " be iMproved; must be first
filetype off

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1

set history=1000            " keep 1000 lines of command history
set undolevels=1000
set autoread                " reload files changed outside vim

set hidden                  " allow buffer switching without saving
set backspace=indent,eol,start  " backspace over everything in insert mode
set whichwrap+=<,>,h,l      " arrow keys wrap across lines

" No bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" ── Backup / swap / undo ─────────────────────────────────────────────────────
set nobackup
set noswapfile
set nowritebackup

" Persistent undo
if has('persistent_undo')
    let s:undo_dir = expand('~/.vim/undo')
    if !isdirectory(s:undo_dir)
        call mkdir(s:undo_dir, 'p')
    endif
    let &undodir = s:undo_dir
    set undofile
endif

" ── UI ────────────────────────────────────────────────────────────────────────
syntax enable
set number                  " show line numbers
set relativenumber          " relative line numbers
set ruler
set showcmd
set showmatch               " highlight matching brackets
set laststatus=2            " always show status line
set wildmenu                " command-line completion
set wildmode=list:longest
set scrolloff=5             " keep 5 lines above/below cursor
set sidescrolloff=5
set cursorline              " highlight current line
set signcolumn=yes

" Status line
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" ── Colors ────────────────────────────────────────────────────────────────────
set background=dark
if has('termguicolors')
    set termguicolors
endif
" Try a built-in colorscheme; users can override in ~/.vimrc.local
silent! colorscheme desert

" ── Search ────────────────────────────────────────────────────────────────────
set incsearch               " incremental search
set hlsearch                " highlight matches
set ignorecase              " case-insensitive search...
set smartcase               " ...unless pattern contains uppercase
set wrapscan                " searches wrap around end of file

" ── Indentation ──────────────────────────────────────────────────────────────
filetype plugin indent on
set autoindent
set smartindent
set expandtab               " use spaces, not tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround              " round indent to multiple of shiftwidth

" Language-specific overrides
autocmd FileType javascript,typescript,json,yaml,html,css,scss
            \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab

" ── Key mappings ─────────────────────────────────────────────────────────────
let mapleader = ','
let maplocalleader = '\\'

" Clear search highlights
nnoremap <leader>/ :nohlsearch<CR>

" Quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Indent/outdent while keeping selection
vnoremap < <gv
vnoremap > >gv

" Toggle paste mode
nnoremap <leader>pp :set paste!<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Strip trailing whitespace
nnoremap <leader>ss :%s/\s\+$//e<CR>

" ── Miscellaneous ─────────────────────────────────────────────────────────────
set ttyfast
set lazyredraw
set clipboard=unnamedplus   " use system clipboard (requires +clipboard)
set mouse=a                 " enable mouse support

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" ── Local overrides ───────────────────────────────────────────────────────────
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
