let s:suite  = themis#suite('ctrlp-gonosen test')
let s:assert = themis#helper('assert')

let s:V  = vital#of('gonosen')
let s:FP = s:V.import('System.Filepath')

function! s:suite.load_bookmarks_test() abort
  let file = s:FP.join(getcwd(), 'test', 'files', 'bookmark.txt')
  let ret  = gonosen#load_bookmarks(file)
  call s:assert.equals(ret, ['./autoload'])
endfunction

function! s:suite.load_repositories_test() abort
  let ret = gonosen#load_repositories()

  " FIXME
  if executable('ghq')
    call s:assert.not_empty(ret)
  else
    call s:assert.empty(ret)
  endif
endfunction

function! s:suite.load_unite_bookmarks_test() abort
  let g:unite_source_bookmark_directory =
      \ s:FP.join(getcwd(), 'test', 'files', 'unite', 'bookmark')
  let ret = gonosen#load_unite_bookmarks()
  call s:assert.equals(ret, ['~/unite/bar/', '~/unite/world/'])
endfunction

function! s:suite.load_ctrlp_bookmarks_test() abort
  let g:gonosen#ctrlp_bookmark_file =
      \ s:FP.join(getcwd(), 'test', 'files', 'ctrlp', 'cache.txt')
  let ret = gonosen#load_ctrlp_bookmarks()
  call s:assert.equals(ret, ['~/ctrlp/bar', '~/ctrlp/world'])
endfunction
