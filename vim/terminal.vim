" Use F11 to trigger window commands in terminal. Ctrl-W is the default, which I
" want to retain for deleting the previous word such as in terminal.
set termwinkey=<f11>

" Use <leader>T to open terminal in a split. Use <leader><c-t> to open terminal
" in a new tab.
function! OpenTerminal(newtab)
	" Store initial working directory.
	let l:cwd = getcwd()

	" Open in vertical split if window is wide enough.
	let l:fileDir = expand("%:p:h")
	execute "cd " . l:fileDir
	if a:newtab
		tabnew
		terminal ++curwin
	else
		if winwidth(0) > 160
			vertical terminal
		else
			terminal
		endif
	endif

	" Restore initial working directory.
	execute "cd " . l:cwd
endfunction
nnoremap <leader>T :call OpenTerminal(0)<cr>
nnoremap <leader><c-t> :call OpenTerminal(1)<cr>

" In terminal, use Ctrl-N to go to the next window. Define the same for normal
" mode for consistency.
tnoremap <c-n> <f11>w
nnoremap <c-n> <c-w>w

" In terminal, use Ctrl-O to paste from the default Vim register.
tnoremap <c-o> <f11>""
