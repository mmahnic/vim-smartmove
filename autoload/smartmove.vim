" vim: set fileencoding=utf-8 sw=2 ts=8 et:vim
" Name:          smartmove.vim
" Author:        Marko Mahnič <marko.mahnic@....si>
" Purpose:       Enhance some movement commands
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.

if vxlib#plugin#StopLoading("#au#smartmove")
  finish
endif


function smartmove#SmartHome(mode)
  let curcol = col(".")
  "gravitate towards beginning for wrapped lines
  if curcol > indent(".") + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol > indent(".") + 1
    if &wrap
      normal! g^
    else
      normal! ^
    endif
  else
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif
endfunction

function smartmove#SmartEnd(mode)
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1
  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif
  if curcol < lastcol
    if &wrap
      normal! g$
    else
      normal! $
    endif
  else
    normal! g_
  endif
  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif
endfunction

function smartmove#SmartScreenTop(count) range
  if a:count
    exec "normal! " . a:count . "H"
    return
  endif
  let l:curline = line('.')
  if l:curline == 1
    " pass
  elseif winline() <= &scrolloff+1
    exec "normal! \<c-u>\<c-u>"
  else
    normal! H
    if line('.') >= l:curline " haven't moved
      exec "normal! \<c-u>\<c-u>"
    endif
  endif
endfunction

function smartmove#SmartScreenBottom(count) range
  if a:count
    exec "normal! " . a:count . "L"
    return
  endif
  let l:curline = line('.')
  if l:curline == line('$')   " last line in buffer
    " pass
  elseif winline() >= winheight(0) - &scrolloff
    exec "normal! \<c-d>\<c-d>"
  else
    normal! L
    if line('.') <= l:curline " haven't moved
      exec "normal! \<c-d>\<c-d>"
    endif
  endif
endfunction

function! smartmove#NextHelpLink(forward, onscreen)
  let retag = '|\S\+|'
  if a:forward | let bflag = ''
  else
    let bflag = 'b'
    normal! h
  endif
  if !a:onscreen
    let found = search(retag, bflag . 'w')
  else
    if a:forward | let lend = line('w$')
    else | let lend = line('w0')
    endif
    let pos = getpos('.')
    let found = search(retag, bflag . 'W', lend)
    if !found
      if a:forward | exec 'normal! H'
      else | exec 'normal! L'
      endif
      let found = search(retag, bflag . 'W', lend)
      if !found
        call setpos('.', pos)
      endif
    endif
  endif
  if found
    normal! l
  endif
endfunction

" install:
"   SmMapHomeEnd()
function smartmove#MapHomeEnd()
  let vpostfix = "<bar>msgv's"
  nmap <silent><Home> :call smartmove#SmartHome('n')<CR>
  nmap <silent><End> :call smartmove#SmartEnd('n')<CR>
  "imap <silent><Home> <C-r>=smartmove#SmartHome('i')<CR>
  "imap <silent><End> <C-r>=smartmove#SmartEnd('i')<CR>
  exec "vmap <silent><Home> <Esc>:call smartmove#SmartHome('v')<CR>" . vpostfix
  exec "vmap <silent><End> <Esc>:call smartmove#SmartEnd('v')<CR>" . vpostfix
endfunction

" install:
"   MapSmartScreen("n", "H", "L")
"   MapSmartScreen("v", "H", "L")
"function smartmove#MapSmartScreen(mode, keytop, keybottom)
"  let postfix = "<CR>"
"  if a:mode == "n" | let prefix = " :call "
"  " elseif a:mode == "i" | let prefix = " <C-r>="
"  elseif a:mode == "v"
"    let prefix = " :<C-u>exec 'normal! gv'<bar>call "
"    let postfix = "<CR><bar>msgv's"
"  else
"    return
"  endif
"  exec a:mode . "map <silent> " . a:keytop . prefix . "smartmove#SmartScreenTop(v:count)" . postfix
"  exec a:mode . "map <silent> " . a:keybottom . prefix . "smartmove#SmartScreenBottom(v:count)" . postfix
"endfunction

function! smartmove#InstallNextHelpTag()
  if &buftype == 'help' || &filetype == 'help' && &readonly
    nmap <silent> <buffer> <tab> :call smartmove#NextHelpLink(1,1)<cr>
    nmap <silent> <buffer> <s-tab> :call smartmove#NextHelpLink(0,1)<cr>
  endif
endfunction

" =========================================================================== 
" Global Initialization - Processed by Plugin Code Generator
" =========================================================================== 
finish

" smartmove.vim will be autoloaded when ft set to help
" <VIMPLUGIN id="smartmove#nexthelptag">
  augroup smartmoveNextHelpTag
    autocmd!
    autocmd FileType help call smartmove#InstallNextHelpTag()
  augroup END
" </VIMPLUGIN>

" smartmove.vim will be autoloaded when a mapped key is pressed
" (the defined function is a copy of #MapSmartScreen)
" (funny idea: map the keys to smartmove#MapSmartScreen and redefine them there)
" <VIMPLUGIN id="smartmove#smartscreen">
  function s:SmartMove_MapSmartScreen(mode, keytop, keybottom)
    let postfix = "<CR>"
    if a:mode == "n" | let prefix = " :call "
    " elseif a:mode == "i" | let prefix = " <C-r>="
    elseif a:mode == "v"
      let prefix = " :<C-u>exec 'normal! gv'<bar>call "
      let postfix = "<CR><bar>msgv's"
    else
      return
    endif
    exec a:mode . "map <silent> " . a:keytop . prefix . "smartmove#SmartScreenTop(v:count)" . postfix
    exec a:mode . "map <silent> " . a:keybottom . prefix . "smartmove#SmartScreenBottom(v:count)" . postfix
  endfunction
  call s:SmartMove_MapSmartScreen('n', 'H', 'L')
  call s:SmartMove_MapSmartScreen('v', 'H', 'L')
  delfunction s:SmartMove_MapSmartScreen
" </VIMPLUGIN>
