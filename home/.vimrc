set nocompatible
syntax on
set cursorline 
hi CursorLine ctermbg=DarkGray ctermfg=White
filetype on

set modeline
set modelines=5

let asmsyntax="nasm"

set t_Co=256
set number
colorscheme molokai
let g:molokai_original = 1
set expandtab
set tabstop=4
set autoindent
set ls=2
set scrolloff=999
set wildmenu

inoremap { {<CR>}<Esc>ko<Tab>
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap :<CR> :<CR><Tab>

"insert single before character
"must be in normal mode
nnoremap <Space> i_<Esc>r

"map  jj and kk to esc
inoremap jj <Esc>:w<CR>
inoremap kk <Esc>:w<CR>

"hitting F4 in normal mode clears search highlights
nnoremap <silent> <F4> :set hlsearch! hlsearch?<CR><Bar>:echo<CR>

"print the stats of the file or selection
nnoremap <F5> g<C-g>
vnoremap <F5> g<C-g>
