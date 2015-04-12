""
" *ctrlp-gonosen.vim* is a CtrlP extension to specify a directory before
" selecting file with CtrlP.
"
" Requirement:
"  - Vim 7.0 or later
"  - CtrlP
"    https://github.com/ctrlpvim/ctrlp.vim
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
" Default value is '~/.bookmark'.
"
if !exists('g:gonosen#bookmark_file')
  let g:gonosen#bookmark_file = '~/.bookmark'
endif

""
" @var
" Unite Bookmark name.
" Default value is 'default'.
if !exists('g:gonosen#unite_bookmark_name')
  let g:gonosen#unite_bookmark_name = 'default'
endif

" check whether specified directory does not match to
" |g:ctrlp_custom_ignore| or not
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

" Get unite-bookmark directory.
function! s:get_unite_bookmark_dir() abort
  if exists('g:unite_source_bookmark_directory')
    return g:unite_source_bookmark_directory
  endif

  if exists('g:unite_data_directory')
    return s:FP.join(g:unite_data_directory, 'bookmark')
  endif

  if expand('$XDG_CACHE_HOME') !=# '$XDG_CACHE_HOME'
    return s:FP.join('$XDG_CACHE_HOME', 'unite', 'bookmark')
  endif

  return s:FP.join('~', '.cache', 'unite', 'bookmark')
endfunction

""
" Return unite-bookmark directories.
" Unite bookmark file is defined by |g:gonosen#unite_bookmark_name|.
"
function! gonosen#load_unite_bookmarks() abort
  let file = expand(s:FP.join(
      \ s:get_unite_bookmark_dir(),
      \ g:gonosen#unite_bookmark_name))

  if filereadable(file)
    return s:_.chain(readfile(file))
        \.rest()
        \.map('split(v:val, "\t")')
        \.map('v:val[1]')
        \.value()
  endif
  return []
endfunction

""
" Return candidates that are shown in CtrlP.
"
function! gonosen#get_candidates() abort
  let dirs = gonosen#load_bookmarks(g:gonosen#bookmark_file)
      \ + gonosen#load_repositories()
      \ + gonosen#load_unite_bookmarks()

  return s:_.chain(dirs)
      \.filter(function('s:does_not_match_custom_ignore'))
      \.uniq()
      \.value()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
