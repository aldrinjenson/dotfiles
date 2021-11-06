set rnu
set nu
set ignorecase
set smartcase
"set mouse=a
"filetype plugin on
"set nocompatible
"colorscheme monokai

let mapleader=" "

call plug#begin('~/.vim/plugged')
   Plug 'neoclide/coc.nvim', {'branch': 'release'}
   Plug 'SirVer/ultisnips'
   Plug 'jiangmiao/auto-pairs'
   Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
 " Plug 'vimwiki/vimwiki'
call plug#end()


""""""""""""""""Coc Config begin""""""""""""""""""""""""""""""""""""""""""""""
    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    nmap <leader>e :CocCommand explorer<CR>

"""""""""""""""Coc config end""""""""""""""""""""""""""""""""""""""""""""""""

function ToggleLinuNumbers()
  set relativenumber! 
  set number !
endfunction
 
noremap <silent> <S-l> :call ToggleLinuNumbers()<CR>
source ~/.vim/vcomments.vim
noremap <silent> <C-_>  :call CommentLine()<CR>

source ~/.vim/code-runner.vim
map <C-q> :call RunCode()<CR>

"""""""""""""""""""""" custom auto closing brackets and quotes """"""""""""""""""""""
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap " ""<left>
" inoremap ` ``<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O
" inoremap '' ''
" inoremap "" ""
" inoremap () ()
"""""""""""""""""""""" custom auto closing brackets and quotes end """""""""""""""""""
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'


set tabstop=4
set shiftwidth=2
set softtabstop=2
set expandtab

au BufNewFile,BufRead *.ejs set filetype=html
autocmd BufNewFile *.sh 0r ~/.vim/templates/bash-skeleton.sh
