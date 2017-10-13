set nocompatible
syntax on
set cursorline 
hi CursorLine ctermbg=DarkGray ctermfg=White
filetype on
"filetype off

"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()

"Plugin 'VundleVim/Vundle.vim'
"Plugin 'xxc3nsoredxx/yab'
"Plugin 'jelera/vim-javascript-syntax'
"Plugin 'Valloric/YouCompleteMe'
"let g:ycm_add_preview_to_completeopt=0
"let g:ycm_confirm_extra_conf=0
"set completeopt-=preview
"Plugin 'marijnh/tern_for_vim'
"Plugin 'pangloss/vim-javascript'

"call vundle#end()
"filetype plugin on

"let g:yab_key_override = 1

set t_Co=256
set number
colorscheme molokai
let g:molokai_original = 1
set expandtab
set ts=4
set autoindent
set ls=2

inoremap { {<CR>}<Esc>ko<Tab>
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap :<CR> :<CR><Tab>
"inoremap <S-Tab> <C-Q><Tab>

"set foldmethod syntax
"set foldnestmax=10
"set foldlevel=1

"insert single before character
"must be in normal mode
nnoremap <Space> i_<Esc>r

"map  jj and kk to esc
inoremap jj <Esc>:w<CR>
inoremap kk <Esc>:w<CR>

"hitting escape in normal mode clears search highlights
nnoremap <silent> <F4> :set hlsearch! hlsearch?<CR><Bar>:echo<CR>

"get the word count of the file
nnoremap <F5> :! wc -w %<CR>
