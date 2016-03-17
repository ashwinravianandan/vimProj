" This plugin is a collection of functions to manage working directory path

let g:projectEntries = []

function! s:initialize()
   let l:FileName =  $HOME . "/.vimproj"
   if filereadable( l:FileName )
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
   endif
endfunction

function! SetProject( projectName )
   for item in g:projectEntries
      for [key,value] in items(item)
         if a:projectName ==# key
            execute "lcd! " . value
            return 1
         endif
      endfor
   endfor
   return 0
endfunction

function! CompleteFunc( ArgLead, CmdLine, CursorPos)
   let l:Keys = []
   for item in g:projectEntries
      for [key,value] in items(item)
         if key =~ a:ArgLead
            call add( l:Keys, key )
         endif
      endfor
   endfor
   return l:Keys
endfunction

function! OpenProject( )
   let l:ProjName = input( "Enter Project: ","", "customlist,CompleteFunc" )
   if SetProject( l:ProjName )
      enew
      Explore
   endif
endfunction

call s:initialize()
