" Use VxLib plugin registration without loading VxLib
let g:loadedPlugins = get(g:, 'loadedPlugins', {})
if get(g:loadedPlugins, 'smartmove', 0)
   finish
endif
let g:loadedPlugins['smartmove'] = 1


" DOC Options: 
"   - map_next_help_tag=1: Automatically map the next-help-tag function calls
"     on tab and shift-tab.
"
"   - map_screen_top_bottom=1: Automatically map the smart screen-top and
"     screen-bottom function calls.
"
"   - screen_top_bottom_maps: List of triplets [mapcommand, up-key, down-key]
"
"   - map_home_end=1: Automatically map the smart home and end function calls.
"
"   - home_end_maps: List of triplets [ mapcommand, home-key, end-key ]
"
let g:plug_smartmove = get(g:, 'plug_smartmove', {})


if get(g:plug_smartmove, 'map_next_help_tag', 1) > 0
   augroup smartmoveNextHelpTag
      autocmd!
      autocmd FileType help call smartmove#InstallNextHelpTag()
   augroup END
endif

if get(g:plug_smartmove, 'map_screen_top_bottom', 1) > 0
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

   let s:maps = get(g:plug_smartmove, 'screen_top_bottom_maps', [
            \ [ 'nmap', 'H', 'L' ],
            \ [ 'vmap', 'H', 'L' ] ])

   for mapdef in s:maps
      call s:Install_MapSmartScreen(mapdef[0], mapdef[1], mapdef[2])
   endfor
   unlet s:maps
   delfunction s:Install_MapSmartScreen
endif

if get(g:plug_smartmove, 'map_home_end', 1) > 0
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

   let s:maps = get( g:plug_smartmove, 'home_end_maps', [
            \ [ 'nmap', '<Home>', '<End>' ],
            \ [ 'vmap', '<Home>', '<End>' ] ] )
   for mapdef in s:maps
      call s:Install_MapHomeEnd(mapdef[0], mapdef[1], mapdef[2])
   endfor
   unlet s:maps
   delfunction s:Install_MapHomeEnd
endif

