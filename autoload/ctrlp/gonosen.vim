if (exists('g:loaded_ctrlp_gonosen') && g:loaded_ctrlp_gonosen) || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_gonosen = 1

call add(g:ctrlp_ext_vars, {
    \ 'init'     : 'ctrlp#gonosen#init()',
    \ 'accept'   : 'ctrlp#gonosen#accept',
    \ 'lname'    : 'ctrlp-gonosen',
    \ 'sname'    : 'gonosen',
    \ 'type'     : 'path',
    \ 'sort'     : 0,
    \ 'specinput': 0,
    \ })

function! ctrlp#gonosen#init() abort
  return gonosen#get_candidates()
endfunction

function! ctrlp#gonosen#accept(mode, dir) abort
  call ctrlp#exit()
  execute ':CtrlP ' . a:dir
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#gonosen#id() abort
  return s:id
endfunction
