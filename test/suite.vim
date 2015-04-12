let s:suite  = themis#suite('foo test')
let s:assert = themis#helper('assert')

let s:V  = vital#of('gonosen')
let s:FP = s:V.import('System.Filepath')

function! s:suite.load_bookmarks_test() abort
  let file = s:FP.join(getcwd(), 'test', 'files', 'bookmark.txt')
  let ret  = gonosen#load_bookmarks(file)
  call s:assert.equals(['./autoload'], ret)
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
