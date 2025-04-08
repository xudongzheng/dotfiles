function! MarkdownSectionCopy()
	let l:back_line = search('\*\*\*', "bnW")
	let l:forward_line = search('\*\*\*', "nW")
	if l:back_line == 0 || l:forward_line == 0
		return
	endif
	execute l:back_line + 2
	normal! V
	execute l:forward_line - 2
	normal! y
	call ClipboardReformatCopy()
endfunction

function! MapMarkdownSnippets()
	" Use <leader>c for checking and unchecking a checkbox.
	nnoremap <buffer> <leader>c :s/\[x\]/[_]/e<cr>:s/\[ \]/[x]/e<cr>:s/\[_\]/[ ]/e<cr>

	" Use <leader>* to copy the text in between *** to clipboard.
	nnoremap <buffer> <leader>* :call MarkdownSectionCopy()<cr>

	" Use <leader><cr>1 through <leader><cr>6 for making a line into a heading.
	nnoremap <buffer> <leader><cr>1 I# <esc>
	nnoremap <buffer> <leader><cr>2 I## <esc>
	nnoremap <buffer> <leader><cr>3 I### <esc>
	nnoremap <buffer> <leader><cr>4 I#### <esc>
	nnoremap <buffer> <leader><cr>5 I##### <esc>
	nnoremap <buffer> <leader><cr>6 I###### <esc>

	" Use <leader><c-b> to make the selected text bold. Use <leader><c-i> for
	" italics.
	xnoremap <buffer> <leader><c-b> c****<esc><left>P
	xnoremap <buffer> <leader><c-i> c**<esc>P

	" Use <leader><c-l> to make the selected text a link.
	xnoremap <buffer> <leader><c-l> c[]<esc>P<right>a()<esc>
endfunction
autocmd FileType markdown call MapMarkdownSnippets()
