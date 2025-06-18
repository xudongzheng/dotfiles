" Use F11 to trigger window commands in terminal. Ctrl-W is the default, which I
" want to retain for deleting the previous word such as in terminal.
set termwinkey=<f11>

" Use <leader>T to open terminal in a split. Use <leader><c-t> to open terminal
" in a new tab.
function! OpenTerminal(newtab)
	" Store initial working directory.
	let l:cwd = getcwd()

	" If buffer is a normal buffer, change to directory containing file. Skip if
	" Vim is used as a pager for example.
	if &l:buftype == ""
		let l:fileDir = expand("%:p:h")
		execute "cd " . l:fileDir
	endif

	" Open in vertical split if window is wide enough.
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

	" Restore initial working directory if needed.
	execute "cd " . l:cwd
endfunction
nnoremap <leader>T :call OpenTerminal(v:false)<cr>
nnoremap <leader><c-t> :call OpenTerminal(v:true)<cr>

" In terminal, use Ctrl-N to go to the next window. This is set for normal mode
" as well to have one single combination for cycling between windows.
tnoremap <c-n> <f11>w
nnoremap <c-n> <c-w>w

" In terminal, use Ctrl-O to paste from the default Vim register.
tnoremap <c-o> <f11>""
