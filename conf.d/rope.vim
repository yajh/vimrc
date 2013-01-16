"Use my rope stuff
"autocmd FileType python set omnifunc=RopeCompleteFunc
autocmd FileType python set omnifunc=pythoncomplete#Complete
"
"let ropevim_codeassist_maxfixes=10
"let ropevim_vim_completion=1
"let ropevim_extended_complete=1
"let ropevim_guess_project=1
"let ropevim_local_prefix="<LocalLeader>r"
"let ropevim_global_prefix="<LocalLeader>p"
"au FileType python map <buffer> ,r :RopeRename<CR>
""let ropevim_enable_shortcuts=0
"
"if has('python')
"python << EOF
"import sys, os
"for path in ("", "/rope", "/ropemode"):
"    sys.path.append(os.path.expanduser('~/.vim/manual/ropevim' + path)) # XXX
"EOF
"endif
"let ropevim_enable_autoimport=0


"Function to activate a virtualenv in the embedded interpreter for
" omnicomplete and other things like that.
"    function LoadVirtualEnv(path)
"        let activate_this = a:path . '/bin/activate_this.py'
"        if getftype(a:path) == "dir" && filereadable(activate_this)
"            python << EOF
"import vim
"    activate_this = vim.eval('l:activate_this')
"    execfile(activate_this, dict(__file__=activate_this))
"EOF
"        endif
"    endfunction
"
""Load up a 'stable' virtualenv if one exists in ~/.virtualenv
"
"let defaultvirtualenv = $HOME . "/.virtualenvs/stable"
"
"" Only attempt to load this virtualenv if the defaultvirtualenv
"" actually exists, and we aren't running with a virtualenv active.
"if has("python")
"    if empty($VIRTUAL_ENV) &&
"        getftype(defaultvirtualenv) == "dir"
"        call LoadVirtualEnv(defaultvirtualenv)
"    endif
"endif
