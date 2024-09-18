function! ClipboardExternal(suffix)
	call system("bash " . g:dotfiles_dir . "clipboard/copy.sh " . a:suffix, getreg('"'))
	if v:shell_error
		echoerr "Unable to copy to clipboard"
	endif
endfunction

function! ClipboardOperator(type, suffix)
	" Copy to default register. The first case is for character motion (such as
	" yanking some words), the second is for line motion (such as yanking some
	" lines), and the last is for visual mode.
	if a:type ==# "char"
		execute "normal! `[v`]" . a:suffix
	elseif a:type ==# "line"
		execute "normal! `[V`]" . a:suffix
	else
		execute "normal! gv" . a:suffix
	endif

	call ClipboardExternal("")
endfunction

" Use <leader>j to copy to system clipboard. In normal mode, it triggers an
" operator that takes a motion. In visual mode, it handles the selected text.
function! ClipboardOperatorCopy(type)
	call ClipboardOperator(a:type, "y")
endfunction
nnoremap <leader>j :set operatorfunc=ClipboardOperatorCopy<cr>g@
xnoremap <leader>j :<c-u>call ClipboardOperatorCopy(visualmode())<cr>

" Define <leader>x, the cut version of <leader>j.
function! ClipboardOperatorCut(type)
	call ClipboardOperator(a:type, "x")
endfunction
nnoremap <leader>x :set operatorfunc=ClipboardOperatorCut<cr>g@
xnoremap <leader>x :<c-u>call ClipboardOperatorCut(visualmode())<cr>

function! ClipboardReformatOperator(type, suffix)
	call ClipboardOperator(a:type, a:suffix)
	let l:formatted = system("python3 " . g:dotfiles_dir . "shell/format-md.py", getreg('"'))
	call setreg('"', l:formatted)
	call ClipboardExternal("")
endfunction

" Use <leader>J to reformat selection with arbitrary width and copy to
" clipboard. This is useful for writing messages in Vim before sending with an
" external application. The operator function does not handle the char type
" since reformatting makes no sense in that context.
function! ClipboardReformatOperatorCopy(type)
	call ClipboardReformatOperator(a:type, "y")
endfunction
nnoremap <leader>J :set operatorfunc=ClipboardReformatOperatorCopy<cr>g@
xnoremap <leader>J :<c-u>call ClipboardReformatOperatorCopy(visualmode())<cr>

" Define <leader>X, the cut version of <leader>J.
function! ClipboardReformatOperatorCut(type)
	call ClipboardReformatOperator(a:type, "x")
endfunction
nnoremap <leader>X :set operatorfunc=ClipboardReformatOperatorCut<cr>g@
xnoremap <leader>X :<c-u>call ClipboardReformatOperatorCut(visualmode())<cr>

" Use <leader>r and <leader>R to copy the relative and absolute file/directory
" path to clipboard. This comes from https://bit.ly/2TdYq0O. On remote systems
" without a clipboard, the path is only copied to the default Vim register.
nnoremap <leader>r :let @" = expand("%")<cr>:call ClipboardExternal("-q")<cr>
nnoremap <leader>R :let @" = expand("%:p")<cr>:call ClipboardExternal("-q")<cr>
