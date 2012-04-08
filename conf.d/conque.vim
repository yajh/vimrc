" Embed a shell (any shell!) into vim

"command! CV ConqueTermVSplit
""command! -nargs=+ CC ConqueTerm(<q-args>)
"command -nargs=+ CC ConqueTerm <q-args>
"command! CS ConqueTermSplit
command! Ipy ConqueVSplit ipython

command! -nargs=+ -complete=shellcmd CC call conque_term#open(<q-args>)
command! -nargs=+ -complete=shellcmd CS call conque_term#open(<q-args>, ['belowright split'])
command! -nargs=+ -complete=shellcmd CV call conque_term#open(<q-args>, ['belowright vsplit'])
command! -nargs=+ -complete=shellcmd CT call conque_term#open(<q-args>, ['tabnew'])
