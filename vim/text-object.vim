" Define function for custom text objects that support multiple character sets.
" This exists for convenience and isn't expected to handle all edge cases,
" particularly when there are multiple in close proximity.
function! SelectTextObject(charsets, command)
	" Define variables for tracking which quote character is the nearest.
	let l:best_before_char = ""
	let l:best_after_char = ""
	let l:best_length = -1

	" Iterate over the character sets to find the nearest pair.
	for l:charset in a:charsets
		let l:before_char = l:charset[0]
		let l:after_char = l:charset[1]
		" Search for nearest character. The c flag includes the character under
		" the cursor. The n flag maintains the current cursor position. The W
		" flag prevents wrapping around the beginning and end of the file.
		let l:back_pos = searchpos(l:before_char, "bcnW")
		let l:forward_pos = searchpos(l:after_char, "cnW")

		" Skip if either back or forward search not found.
		if l:back_pos[0] == 0 || l:forward_pos[0] == 0
			continue
		endif

		" Use length between pair to determine which is the closest.
		let l:back_byte = line2byte(l:back_pos[0]) + l:back_pos[1]
		let l:forward_byte = line2byte(l:forward_pos[0]) + l:forward_pos[1]
		let l:quote_length = l:forward_byte - l:back_byte
		if l:best_length == -1 || l:quote_length < l:best_length
			let l:best_before_char = l:before_char
			let l:best_after_char = l:after_char
			let l:best_length = l:quote_length
		endif
	endfor

	if l:best_before_char != ""
		" If character under the cursor matches, use Vim's builtin selection
		" mechanism; this edge case not easy to handle manually. Also use
		" builtin mechanism if the before and after delimiters are different.
		" This is not used universally for quotes since it cannot select across
		" multiple lines. See https://bit.ly/4go5xvw for details.
		let l:current_char = getline(".")[col(".") - 1]
		if l:best_before_char != l:best_after_char || l:best_before_char == l:current_char || l:best_after_char == l:current_char
			execute "normal! v" . a:command . l:best_before_char
			return
		endif

		" Select quotes by searching backwards and forwards.
		if a:command == "i"
			let l:back_suffix = "\<space>"
			let l:forward_suffix = "\<bs>"
		else
			let l:back_suffix = ""
			let l:forward_suffix = ""
		endif
		execute "normal! ?" . l:best_before_char . "\<cr>" . l:back_suffix
		normal! v
		execute "normal! /" . l:best_after_char . "\<cr>" . l:forward_suffix
	endif
endfunction

function! SelectQuotes(command)
	let l:charsets = [['"', '"'], ["'", "'"], ["`", "`"]]
	call SelectTextObject(l:charsets, a:command)
endfunction

function! SelectBlocks(command)
	let l:charsets = [["(", ")"], ["{", "}"], ["[", "]"], ["<", ">"]]
	call SelectTextObject(l:charsets, a:command)
endfunction

" Define text object that work around multiple quote characters. This uses c
" (for comilla) instead of q since ac is easier to type than aq.
onoremap uc :<c-u>call SelectQuotes("i")<cr>
xnoremap uc :<c-u>call SelectQuotes("i")<cr>
onoremap ac :<c-u>call SelectQuotes("a")<cr>
xnoremap ac :<c-u>call SelectQuotes("a")<cr>

" Redefine the block text object to work with parentheses, braces, square
" brackets, and angle brackets.
onoremap ub :<c-u>call SelectBlocks("i")<cr>
xnoremap ub :<c-u>call SelectBlocks("i")<cr>
onoremap ab :<c-u>call SelectBlocks("a")<cr>
xnoremap ab :<c-u>call SelectBlocks("a")<cr>
