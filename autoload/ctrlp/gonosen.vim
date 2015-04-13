if (exists('g:loaded_ctrlp_gonosen') && g:loaded_ctrlp_gonosen) || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_gonosen = 1

call add(g:ctrlp_ext_vars, {
    \ 'init'     : 'ctrlp#gonosen#init()',
    \ 'accept'   : 'ctrlp#gonosen#accept',
    \ 'lname'    : 'ctrlp-gonosen',
    \ 'sname'    : 'gonosen',
    \ 'type'     : 'tabs',
    \ 'sort'     : 0,
    \ 'specinput': 0,
    \ })

function! s:link_highlight(from, to) abort
  if !hlexists(a:from)
    exe 'highlight link' a:from a:to
  endif
endfunction

function! s:set_syntax() abort
  call s:link_highlight('CtrlPGonosenTitle', 'Identifier')
  call s:link_highlight('CtrlPGonosenPath', 'Comment')
  syntax match CtrlPGonosenTitle '^> [^\t]\+'
  syntax match CtrlPGonosenPath '\zs\t.*\ze$'
endfunction

function! ctrlp#gonosen#init() abort
  call s:set_syntax()
  return gonosen#get_candidates()
endfunction

function! ctrlp#gonosen#accept(mode, line) abort
  call ctrlp#exit()
  let dir = split(a:line, g:gonosen#separator)[1]
  execute ':CtrlP ' . dir
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#gonosen#id() abort
  return s:id
endfunction
