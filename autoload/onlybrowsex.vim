"  The original is netrw.vim, which is copyrighted as below:
"  Copyright:    Copyright (C) 2016 Charles E. Campbell {{{1
"                Permission is hereby granted to use and distribute this code,
"                with or without modifications, provided that this copyright
"                notice is copied with it. Like anything else that's free,
"                netrw.vim, netrwPlugin.vim, and netrwSettings.vim are provided
"                *as is* and come with no warranty of any kind, either
"                expressed or implied. By using this plugin, you agree that
"                in no event will the copyright holder be liable for any damages
"                resulting from the use of this software.

fun! onlybrowsex#BrowseX(fname)
  " set up redirection
  if &srr =~ "%s"
    if (has("win32") || has("win95") || has("win64") || has("win16"))
      let redir= substitute(&srr,"%s","nul","")
    else
      let redir= substitute(&srr,"%s","/dev/null","")
    endif
  elseif (has("win32") || has("win95") || has("win64") || has("win16"))
    let redir= &srr . "nul"
  else
    let redir= &srr . "/dev/null"
  endif
  " setup openers
  if has("win32") || has("win64")
    if executable("start")
      sil cal system(["start", "rundll32", "url.dll,FileProtocolHandler", a:fname])
    elseif executable("rundll32")
      sil cal system(["rundll32", "url.dll,FileProtocolHandler", a:fname])
    else
      call netrw#ErrorMsg(s:WARNING,"rundll32 not on path",74)
    endif
    call inputsave()|call input("Press <cr> to continue")|call inputrestore()
    let ret= v:shell_error
  elseif has("unix") && executable("gnome-open") && !s:haskdeinit
    sil cal system(["gnome-open", a:fname])
    let ret= v:shell_error
  elseif has("unix") && executable("kfmclient") && s:haskdeinit
    sil cal system(["kfmclient", "exec", a:fname])
    let ret= v:shell_error
  elseif has("macunix") && executable("open")
    sil cal system(["open", a:fname])
    let ret= v:shell_error
  else
    let ret="this environment is not supported."
  endif
  " restoring redraw! after external file handlers
  redraw!
  if ret
    echoerr ret
  endif
endfun
