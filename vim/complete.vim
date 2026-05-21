function! EnableComplete()
	" Skip if file is for editing shell command.
	if match(expand("%:p"), "^/tmp/bash-fc") == 0 || match(expand("%:p"), "^/private/tmp/") == 0
		return
	endif

	" Enable GitHub Copilot or Windsurf if plugin exists.
	if isdirectory(expand("~/.vim/pack/github/opt/copilot.vim"))
		" Use Ctrl-N instead of Tab for accepting suggestions.
		let g:copilot_no_tab_map = v:true
		inoremap <expr> <c-n> copilot#Accept("")

		packadd copilot.vim
	elseif isdirectory(expand("~/.vim/pack/Exafunction/opt/windsurf.vim"))
		" Disable default key bindings.
		let g:codeium_disable_bindings = v:true

		" Use Ctrl-N instead of Tab for accepting suggestions.
		inoremap <expr> <c-n> codeium#Accept()

		packadd windsurf.vim
		silent CodeiumEnable
	endif
endfunction

autocmd VimEnter * call EnableComplete()
