let s:comment_map = {
      \   "c": '\/\/',
      \   "cpp": '\/\/',
      \   "go": '\/\/',
      \   "java": '\/\/',
      \   "javascript": '\/\/',
      \   "tsx": '\/\/',
      \   "typescript": '\/\/',
      \   "lua": '--',
      \   "scala": '\/\/',
      \   "php": '\/\/',
      \   "python": '#',
      \   "ruby": '#',
      \   "rust": '\/\/',
      \   "sh": '#',
      \   "desktop": '#',
      \   "fstab": '#',
      \   "conf": '#',
      \   "profile": '#',
      \   "bashrc": '#',
      \   "bash_profile": '#',
      \   "mail": '>',
      \   "eml": '>',
      \   "bat": 'REM',
      \   "ahk": ';',
      \   "vim": '"',
      \   "tex": '%',
      \ }

function! CommentLine()
  if has_key(s:comment_map, &filetype)
    let comment_leader = s:comment_map[&filetype]
    if getline('.') =~ "^\\s*" . comment_leader . " "
      " Uncomment the line
      execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
    else
      if getline('.') =~ "^\\s*" . comment_leader
        " Uncomment the line
        execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
      else
        " Comment the line
        execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
      end
    end
  else
    echo "No comment leader found for filetype"
    execute "silent s/^\\(\\s*\\)" . '#' . " /\\1/"
  end
endfunction


nnoremap <leader><Space> :call CommentLine()<cr>
vnoremap <leader><Space> :call CommentLine()<cr>
