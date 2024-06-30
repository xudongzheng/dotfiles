function! AbbrevCSnippets()
	iab <buffer> maintn int main() {<cr><cr>}<up><bs>
	iab <buffer> null NULL

	" Define abbreviations for Zephyr logging. Log function abbreviation
	" expansion should be triggered by typing double quote.
	iab <buffer> enr (err) {<cr>LOG_ERR("TODO TODO TODO (err %d)", err);<cr>}
	iab <buffer> ldbg LOG_DBG(");<left><left><left>
	iab <buffer> linf LOG_INF(");<left><left><left>
	iab <buffer> lwrn LOG_WRN(");<left><left><left>
	iab <buffer> lerr LOG_ERR(");<left><left><left>
	iab <buffer> lxdbg LOG_HEXDUMP_DBG(, , ");<left><left><left>
	iab <buffer> lxinf LOG_HEXDUMP_INF(, , ");<left><left><left>
	iab <buffer> lxwrn LOG_HEXDUMP_WRN(, , ");<left><left><left>
	iab <buffer> lxerr LOG_HEXDUMP_ERR(, , ");<left><left><left>

endfunction
autocmd FileType c,cpp call AbbrevCSnippets()

function! MapCSnippets()
	xnoremap <leader>l csizeof()<esc>P
	xnoremap <leader>L cARRAY_SIZE()<esc>P
endfunction
autocmd FileType c,cpp call MapCSnippets()
