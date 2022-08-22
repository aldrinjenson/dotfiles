function! myspacevim#before() abort
  " Place here those starting with a let keyword 🤷
  " Place everything in the after function
  let g:python3_host_prog='/usr/bin/python3'
  let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn)$',
        \ 'file': '\v\.(exe|so|dll)$',
        \ 'link': 'some_bad_symbolic_links',
        \ }
endfunction

function! myspacevim#after() abort
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip,.git
  set wrap
  " set ic " set ignorecase
  set smartcase
  " set shellcmdflag=-ic
  " to make the shell behave as bash

  " set incsearch
  source /home/aldrin/.SpaceVim.d/autoload/vcomments.vim
  noremap <silent> <C-_>  :call CommentLine()<CR>
  noremap <F3> :Autoformat<CR>
  au BufWrite * :Autoformat " auto format on save

  "navigate to the next linting error
  noremap <F2> :lprevious<CR>
  noremap <F4> :lnext<CR>

  "easier split navigation
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>


  " autocmd BufNewFile *.sh 0r /home/aldrin/.SpaceVim.d/autoload/templates/bash-skeleton.sh

  """"""""""""""""Coc Config begin""""""""""""""""""""""""""""""""""""""""""""""
  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  " command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

  " xmap <leader>f  <Plug>(coc-format-selected)
  " nmap <leader>f  <Plug>(coc-format-selected)
  "
  " nmap <leader>e :CocCommand explorer<CR>
  """""""""""""""Coc config end""""""""""""""""""""""""""""""""""""""""""""""""

endfunction
