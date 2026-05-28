" Load GitHub Copilot or Windsurf if plugin exists. Plugins are stored in opt
" rather than start so it's easier to include or exclude programmatically.
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
endif

function! DisableComplete()
	" Disable autocompletion if Vim is open for editing a shell command.
	if match(expand("%:p"), "^/tmp/bash-fc") == 0 || match(expand("%:p"), "^/private/tmp/zsh") == 0
		if isdirectory(expand("~/.vim/pack/github/opt/copilot.vim"))
			let b:copilot_enabled = v:false
		elseif isdirectory(expand("~/.vim/pack/Exafunction/opt/windsurf.vim"))
			silent Codeium DisableBuffer
		endif
	endif
endfunction

autocmd VimEnter * call DisableComplete()
