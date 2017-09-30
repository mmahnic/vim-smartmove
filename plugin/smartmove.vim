
if exists("g:loaded_smartmove") && g:loaded_smartmove != 0
   finish
endif
let g:loaded_smartmove = 1

" DOC: Automatically map the next-help-tag function calls on tab and shift-tab.
if !exists("g:smartmove_map_next_help_tag")
   let g:smartmove_map_next_help_tag = 1
endif

" DOC: Automatically map the smart screen-top and screen-bottom function calls.
if !exists("g:smartmove_map_screen_top_bottom")
   let g:smartmove_map_screen_top_bottom=1
endif

" DOC: List of triplets [ mapcommand, up-key, down-key ]
if !exists("g:smartmove_screen_top_bottom_maps")
   let g:smartmove_screen_top_bottom_maps = [
            \ [ 'nmap', 'H', 'L' ],
            \ [ 'vmap', 'H', 'L' ] ]
endif

" DOC: Automatically map the smart home and end function calls.
if !exists("g:smartmove_map_home_end")
   let g:smartmove_map_home_end=1
endif

" DOC: List of triplets [ mapcommand, home-key, end-key ]
if !exists("g:smartmove_home_end_maps")
   let g:smartmove_home_end_maps = [
            \ [ 'nmap', '<Home>', '<End>' ],
            \ [ 'vmap', '<Home>', '<End>' ] ]
endif


if g:smartmove_map_next_help_tag > 0
   augroup smartmoveNextHelpTag
      autocmd!
      autocmd FileType help call smartmove#InstallNextHelpTag()
   augroup END
endif

if g:smartmove_map_screen_top_bottom > 0
   function s:Install_MapSmartScreen(mode, keytop, keybottom)
      let postfix = "<CR>"
      if a:mode == "nmap"
         let prefix = " :call "
      " elseif a:mode == "imap" | let prefix = " <C-r>="
      elseif a:mode == "vmap"
         let prefix = " :<C-u>exec 'normal! gv'<bar>call "
         let postfix = "<CR><bar>msgv's"
      else
         return
      endif
      exec a:mode . " <silent> " . a:keytop . prefix . "smartmove#SmartScreenTop(v:count)" . postfix
      exec a:mode . " <silent> " . a:keybottom . prefix . "smartmove#SmartScreenBottom(v:count)" . postfix
   endfunction
   for mapdef in g:smartmove_screen_top_bottom_maps
      call s:Install_MapSmartScreen(mapdef[0], mapdef[1], mapdef[2])
   endfor
   delfunction s:Install_MapSmartScreen
endif

if g:smartmove_map_home_end > 0
   function s:Install_MapHomeEnd(mode, keytop, keybottom)
      let postfix = "<CR>"
      if a:mode == "nmap"
         let prefix = " :call "
      " elseif a:mode == "imap" | let prefix = " <C-r>="
      elseif a:mode == "vmap"
         let prefix = " :<C-u>exec 'normal! gv'<bar>call "
         let postfix = "<CR><bar>msgv's"
      else
         return
      endif
      let modech = a:mode[0]
      exec a:mode . " <silent> " . a:keytop . prefix . "smartmove#SmartHome('" .modech . "')" . postfix
      exec a:mode . " <silent> " . a:keybottom . prefix . "smartmove#SmartEnd('" .modech . "')" . postfix
   endfunction
   for mapdef in g:smartmove_home_end_maps
      call s:Install_MapHomeEnd(mapdef[0], mapdef[1], mapdef[2])
   endfor
   delfunction s:Install_MapHomeEnd
endif
