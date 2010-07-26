" Vim plug-in
" Author: Peter Odding <peter@peterodding.com>
" Last Change: July 20, 2010
" URL: http://peterodding.com/code/vim/easytags/
" Requires: Exuberant Ctags (http://ctags.sf.net)
" License: MIT
" Version: 1.9.7

" Support for automatic update using the GLVS plug-in.
" GetLatestVimScripts: 3114 1 :AutoInstall: easytags.zip

" Don't source the plug-in when its already been loaded or &compatible is set.
if &cp || exists('g:loaded_easytags')
  finish
endif

" Configuration defaults and initialization. {{{1

if !exists('g:easytags_file')
  if has('win32') || has('win64')
    let g:easytags_file = '~\_vimtags'
  else
    let g:easytags_file = '~/.vimtags'
  endif
endif

if !exists('g:easytags_resolve_links')
  let g:easytags_resolve_links = 0
endif

if !exists('g:easytags_always_enabled')
  let g:easytags_always_enabled = 0
endif

if !exists('g:easytags_on_cursorhold')
  let g:easytags_on_cursorhold = 1
endif

if !exists('g:easytags_ignored_filetypes')
  let g:easytags_ignored_filetypes = '^tex$'
endif

function! s:InitEasyTags(version)
  " Check that the location of Exuberant Ctags has been configured or that the
  " correct version of the program exists in one of its default locations.
  if exists('g:easytags_cmd') && s:CheckCtags(g:easytags_cmd, a:version)
    return 1
  endif
  " On Ubuntu Linux, Exuberant Ctags is installed as `ctags'. On Debian Linux,
  " Exuberant Ctags is installed as `exuberant-ctags'. On Free-BSD, Exuberant
  " Ctags is installed as `exctags'.
  for name in ['ctags', 'exuberant-ctags', 'esctags']
    if s:CheckCtags(name, a:version)
      let g:easytags_cmd = name
      return 1
    endif
  endfor
endfunction

function! s:CheckCtags(name, version)
  " Not every executable out there named `ctags' is in fact Exuberant Ctags.
  " This function makes sure it is because the easytags plug-in requires the
  " --list-languages option.
  if executable(a:name)
    let listing = system(a:name . ' --version')
    let pattern = 'Exuberant Ctags \zs\d\+\(\.\d\+\)*'
    let g:easytags_ctags_version = matchstr(listing, pattern)
    return s:VersionToNumber(g:easytags_ctags_version) >= a:version
  endif
endfunction

function! s:VersionToNumber(s)
  let values = split(a:s, '\.')
  if len(values) == 1
    return values[0] * 10
  elseif len(values) >= 2
    return values[0] * 10 + values[1][0]
  endif
endfunction

if !s:InitEasyTags(55)
  if !exists('g:easytags_ctags_version') || empty(g:easytags_ctags_version)
    let msg = "easytags.vim: Plug-in not loaded because Exuberant Ctags isn't installed!"
    if executable('apt-get')
      let msg .= " On Ubuntu & Debian you can install Exuberant Ctags by"
      let msg .= " installing the package named `exuberant-ctags':"
      let msg .= " sudo apt-get install exuberant-ctags"
    else
      let msg .= " Please download & install Exuberant Ctags from http://ctags.sf.net"
    endif
    echomsg msg
  else
    let msg = "easytags.vim: Plug-in not loaded because Exuberant Ctags 5.5"
    let msg .= " or newer is required while you have version %s installed!"
    echomsg printf(msg, g:easytags_ctags_version)
  endif
  finish
endif

function! s:RegisterTagsFile()
  " Parse the &tags option and get a list of all tags files *including
  " non-existing files* (this is why we can't just call tagfiles()).
  let tagfiles = xolox#option#split_tags(&tags)
  let expanded = map(copy(tagfiles), 'resolve(expand(v:val))')
  " Add the filename to the &tags option when the user hasn't done so already.
  if index(expanded, resolve(expand(g:easytags_file))) == -1
    " This is a real mess because of bugs in Vim?! :let &tags = '...' doesn't
    " work on UNIX and Windows, :set tags=... doesn't work on Windows. What I
    " mean with "doesn't work" is that tagfiles() == [] after the :let/:set
    " command even though the tags file exists! One easy way to confirm that
    " this is a bug in Vim is to type :set tags= then press <Tab> followed by
    " <CR>. Now you entered the exact same value that the code below also did
    " but suddenly Vim sees the tags file and tagfiles() != [] :-S
    call insert(tagfiles, g:easytags_file)
    let value = xolox#option#join_tags(tagfiles)
    let cmd = ':set tags=' . escape(value, '\ ')
    if has('win32') || has('win64')
      " TODO How to clear the expression from Vim's status line?
      call feedkeys(":" . cmd . "|let &ro=&ro\<CR>", 'n')
    else
      execute cmd
    endif
  endif
endfunction

" Let Vim know about the global tags file created by this plug-in.
call s:RegisterTagsFile()

" The :UpdateTags and :HighlightTags commands. {{{1

command! -bar -bang UpdateTags call easytags#update_cmd(<q-bang> == '!')
command! -bar HighlightTags call easytags#highlight_cmd()

" Automatic commands. {{{1

augroup PluginEasyTags
  autocmd!
  if g:easytags_always_enabled
    " TODO Also on FocusGained because tags files might be updated externally?
    autocmd BufReadPost,BufWritePost * call easytags#autoload()
  endif
  if g:easytags_on_cursorhold
    autocmd CursorHold,CursorHoldI * call easytags#autoload()
    autocmd BufReadPost * unlet! b:easytags_last_highlighted
  endif
  autocmd User PublishPre HighlightTags
augroup END

" }}}1

" Make sure the plug-in is only loaded once.
let g:loaded_easytags = 1

" vim: ts=2 sw=2 et