""
" *ctrlp-gonosen.vim* is a CtrlP extension to specify a directory before
" selecting file with CtrlP.
"
" Requirement:
"  - Vim 7.0 or later
"  - CtrlP
"
" Lateste Version:
"  - https://github.com/liquidz/ctrlp-gonosen.vim
"

let s:save_cpo = &cpo
set cpo&vim

let s:V  = vital#of('gonosen')
let s:P  = s:V.import('Process')
let s:FP = s:V.import('System.Filepath')
let s:_  = s:V.import('Underscore').import()

""
" @var
" Bookmark file path.
" Default: ~/.bookmark
"
if !exists('g:gonosen#bookmark_file')
  let g:gonosen#bookmark_file = '~/.bookmark'
endif

" check whether specified directory does not match to |g:ctrlp_custom_ignore| or
" not
function! s:does_not_match_custom_ignore(dir, ...) abort
  if exists('g:ctrlp_custom_ignore["dir"]')
    return (match(a:dir, g:ctrlp_custom_ignore['dir']) ==# -1)
  endif
  return 1
endfunction

""
" Return directory array that defined in book mark file.
" Bookmark file is defined by |g:gonosen#bookmark_file|.
"
function! gonosen#load_bookmarks(file) abort
  let file = expand(a:file)
  if filereadable(file)
    return s:_.chain(readfile(file))
        \.filter('isdirectory(v:val)')
        \.value()
  endif
  return []
endfunction

""
" Return repository list that is managed by `ghq`.
" Return empty array if `ghq` is not installed.
"
function! gonosen#load_repositories() abort
  if executable('ghq')
    let repos = s:P.system('ghq list --full-path')
    return split(repos, "\n")
  endif
  return []
endfunction

""
" Return candidates that are shown in CtrlP.
"
function! gonosen#get_candidates() abort
  let dirs = gonosen#load_bookmarks(g:gonosen#bookmark_file)
      \ + gonosen#load_repositories()

  return s:_.chain(dirs)
      \.filter(function('s:does_not_match_custom_ignore'))
      \.uniq()
      \.value()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
