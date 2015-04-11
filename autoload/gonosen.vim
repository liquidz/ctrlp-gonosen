let s:save_cpo = &cpo
set cpo&vim

let s:V  = vital#of('gonosen')
let s:P  = s:V.import('Process')
let s:FP = s:V.import('System.Filepath')
let s:_  = s:V.import('Underscore').import()

if !exists('g:gonosen#bookmark_file')
  let g:gonosen#bookmark_file = '~/.bookmark'
endif

function! s:does_not_match_custom_ignore(dir, ...) abort
  if exists('g:ctrlp_custom_ignore["dir"]')
    return (match(a:dir, g:ctrlp_custom_ignore['dir']) ==# -1)
  endif
  return 1
endfunction

function! gonosen#load_bookmarks(file) abort
  let file = expand(a:file)
  if filereadable(file)
    return s:_.chain(readfile(file))
        \.filter('isdirectory(v:val)')
        \.value()
  endif
  return []
endfunction

function! gonosen#load_repositories() abort
  if executable('ghq')
    let repos = s:P.system('ghq list --full-path')
    return split(repos, "\n")
  endif
  return []
endfunction

function! gonosen#get_directory_list() abort
  let dirs = gonosen#load_bookmarks(g:gonosen#bookmark_file)
      \ + gonosen#load_repositories()

  return s:_.chain(dirs)
      \.filter(function('s:does_not_match_custom_ignore'))
      \.uniq()
      \.value()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
