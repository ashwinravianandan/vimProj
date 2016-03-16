" This plugin is a collection of functions to manage working directory path

let g:projectEntries = []

function! s:initialize()
   let l:FileName =  $HOME . "/.vimproj"
   let l:projEntries = readfile( l:FileName )
   for item in l:projEntries
      if item !~ '^\s*"'
         let l:projName = substitute( item, '^\s*\(.*\)\s*:.*','\1','g')
         let l:projPath = substitute( item, '.*:\s*\(.*\)\s*$','\1','g')
         let l:projDict = {}
         let l:projDict[ l:projName ] = l:projPath
         call add( g:projectEntries, l:projDict )
      endif
   endfor
endfunction

function! SetProject( projectName )
   for item in g:projectEntries
      for [key,value] in items(item)
         if a:projectName ==# key
            execute "lcd! " . value
         endif
      endfor
   endfor
endfunction

function! CompleteFunc( ArgLead, CmdLine, CursorPos)
   let l:Keys = []
   for item in g:projectEntries
      for [key,value] in items(item)
         call add( l:Keys, key )
      endfor
   endfor
   return l:Keys
endfunction

function! OpenProject( )
   let l:ProjName = input( "Enter Project: ","", "customlist,CompleteFunc" )
   call SetProject( l:ProjName )
endfunction

call s:initialize()
