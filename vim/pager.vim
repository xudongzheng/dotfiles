" Define function for loading an output file and using Vim as a pager. This is
" based on https://bit.ly/3WPsno2 and https://bit.ly/42KcV08.
function! LoadPager(path)
	let l:options = {}
	let l:options["hidden"] = 1
	let l:options["term_finish"] = "open"
	let l:options["term_opencmd"] = "buffer %d"
	call term_start("cat " . a:path, l:options)
endfunction
