function! DefineComment(ft, prefix)
	execute "autocmd FileType " . a:ft . " noremap <buffer> <leader>c :normal! I" . a:prefix . " <Esc>"
endfunction

" Use <leader>c to comment code. This should work in normal mode (for the active
" line) and in visual line mode. New file types will be added as needed.
call DefineComment("arduino", "//")
call DefineComment("bash", "#")
call DefineComment("bindzone", ";")
call DefineComment("c", "//")
call DefineComment("cfg", "#")
call DefineComment("cmake", "#")
call DefineComment("conf", "#")
call DefineComment("config", "#")
call DefineComment("cpp", "//")
call DefineComment("crontab", "#")
call DefineComment("cs", "//")
call DefineComment("debsources", "#")
call DefineComment("dockerfile", "#")
call DefineComment("dosini", "#")
call DefineComment("dts", "//")
call DefineComment("gdb", "#")
call DefineComment("gitconfig", "#")
call DefineComment("gitrebase", "#")
call DefineComment("go", "//")
call DefineComment("i3config", "#")
call DefineComment("java", "//")
call DefineComment("javascript", "//")
call DefineComment("kconfig", "#")
call DefineComment("make", "#")
call DefineComment("matlab", "%")
call DefineComment("objc", "//")
call DefineComment("pamconf", "#")
call DefineComment("perl", "#")
call DefineComment("php", "//")
call DefineComment("python", "#")
call DefineComment("readline", "#")
call DefineComment("requirements", "#")
call DefineComment("ruby", "#")
call DefineComment("scala", "//")
call DefineComment("screen", "#")
call DefineComment("sql", "--")
call DefineComment("sshconfig", "#")
call DefineComment("sshdconfig", "#")
call DefineComment("swift", "//")
call DefineComment("tex", "%")
call DefineComment("tmux", "#")
call DefineComment("typescript", "//")
call DefineComment("vim", '"')
call DefineComment("xdefaults", "!")
call DefineComment("yaml", "#")

" Define <leader>c for types like HTML and CSS that only support block comments.
" For normal mode, append before prepend to prevent the comment line from being
" wrapped into multiple lines.
autocmd FileType html,svg,xml nnoremap <buffer> <leader>c A --><esc>I<!-- <esc>
autocmd FileType html,svg,xml xnoremap <buffer> <leader>c c<!--<cr>--><esc>P
autocmd FileType css,ld nnoremap <buffer> <leader>c A */<esc>I/* <esc>
autocmd FileType css,ld xnoremap <buffer> <leader>c c/*<cr><bs><bs><bs>*/<esc>P
