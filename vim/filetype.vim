function! EnableTextSpell()
	if &filetype == ""
		setfiletype text
	endif
	if index(["gitcommit", "markdown", "tex", "text"], &filetype) >= 0
		setlocal spell
	endif
endfunction

" Use augroup to implement custom file type detection logic. See
" https://bit.ly/4f8pgyE for more information.
augroup filetypedetect
	" Use Bash syntax for shell scripts.
	if has("patch-8.2.2434")
		autocmd FileType sh,zsh setfiletype bash
	else
		let g:is_bash = 1
	endif

	" Treat Zephyr overlay files and ZMK keymap files as DeviceTree.
	autocmd BufRead,BufNewFile *.keymap,*.overlay setfiletype dts

	" Treat .fs (F#) and .kt (Kotlin) files as Scala files. They are obviously
	" different but are similar enough for most of syntax highlighting and
	" indentation to work. OCaml is another candidate for F# but it doesn't
	" handle braces well.
	if has("patch-9.0.1908")
		autocmd BufRead,BufNewFile *.fs setfiletype scala
	else
		autocmd BufRead,BufNewFile *.fs,*.kt setfiletype scala
	endif

	" Treat Zephyr config files as regular configuration files.
	autocmd BufRead,BufNewFile .config,*_defconfig setfiletype conf

	" Set filetype for SSH configuration files that are included from the main file.
	autocmd BufRead,BufNewFile ~/.ssh/config-* setfiletype sshconfig

	" Set filetype for SSH known_hosts so <leader>c can be used to comment lines.
	autocmd BufRead,BufNewFile ~/.ssh/known_hosts setfiletype conf

	" Treat all unrecognized files as text files. Additionally, enable spell
	" checking in all text files. Since 'spell' is 'local to window' rather than
	" 'local to buffer', it is necessary to use BufRead and BufNewFile instead
	" of FileType. This combination ensures that the setting takes effect in
	" every window that opens the buffer. With FileType, it would only take
	" effect in the first window that opens the buffer.
	autocmd BufRead,BufNewFile * call EnableTextSpell()
augroup END
