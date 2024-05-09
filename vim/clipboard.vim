function! XclipOperator(type, suffix)
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

	" Copy to system clipboard with xclip.
	if executable("xclip")
		call system("nohup xclip -sel clip &", getreg('"'))
	elseif executable("pbcopy")
		call system("pbcopy", getreg('"'))
	elseif executable("clip.exe")
		call system("clip.exe", getreg('"'))
	endif
endfunction

" Use <leader>j to copy to system clipboard. In normal mode, it triggers an
" operator that takes a motion. In visual mode, it handles the selected text.
function! XclipOperatorCopy(type)
	call XclipOperator(a:type, "y")
endfunction
nnoremap <leader>j :set operatorfunc=XclipOperatorCopy<cr>g@
xnoremap <leader>j :<c-u>call XclipOperatorCopy(visualmode())<cr>

" Define <leader>x, the cut version of <leader>j.
function! XclipOperatorCut(type)
	call XclipOperator(a:type, "x")
endfunction
nnoremap <leader>x :set operatorfunc=XclipOperatorCut<cr>g@
xnoremap <leader>x :<c-u>call XclipOperatorCut(visualmode())<cr>

function! XclipReformatOperator(type, suffix)
	setlocal textwidth=1000
	if a:type ==# "line"
		execute "normal! `[V`]gq"
	else
		execute "normal! gvgqgv"
	endif
	call XclipOperator(a:type, a:suffix)
	setlocal textwidth=80
	if a:type ==# "line"
		execute "normal! `[V`]gq"
	else
		execute "normal! gvgq"
	endif
endfunction

" Use <leader>J to reformat selection with arbitrary width and copy to
" clipboard. This is useful for writing messages in Vim before sending with an
" external application. The operator function does not handle the char type
" since reformatting makes no sense in that context.
function! XclipReformatOperatorCopy(type)
	call XclipReformatOperator(a:type, "y")
endfunction
nnoremap <leader>J :set operatorfunc=XclipReformatOperatorCopy<cr>g@
xnoremap <leader>J :<c-u>call XclipReformatOperatorCopy(visualmode())<cr>

" Define <leader>X, the cut version of <leader>J.
function! XclipReformatOperatorCut(type)
	call XclipReformatOperator(a:type, "x")
endfunction
nnoremap <leader>X :set operatorfunc=XclipReformatOperatorCut<cr>g@
xnoremap <leader>X :<c-u>call XclipReformatOperatorCut(visualmode())<cr>
