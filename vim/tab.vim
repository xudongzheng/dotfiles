function! SetTabWidth(tab_width, tab_indent, priority)
	" If priority is lower, ignore.
	if !exists("b:tab_width_prio")
		let b:tab_width_prio = 0
	endif
	if a:priority < b:tab_width_prio
		return
	endif
	let b:tab_width_prio = a:priority

	" Set settings based on whether tabs or spaces are used for indentation.
	if a:tab_indent
		setlocal noexpandtab softtabstop=0
		let &l:shiftwidth = a:tab_width
		let &l:tabstop = a:tab_width
	else
		setlocal expandtab
		let &l:shiftwidth = a:tab_width
		let &l:tabstop = a:tab_width
		let &l:softtabstop = a:tab_width
	endif
endfunction

" Define tab settings. By default (priority 0), use tabs for indentation.
" BufWinEnter is needed for reading from standard input as well as buffers
" created with :new. FileType is needed to override Vim defaults for types like
" as Python. Projects can override tab settings with priority 1. Files such as
" YAML can further override with priority 2.
autocmd BufWinEnter,FileType * call SetTabWidth(4, v:true, 0)
autocmd FileType yaml call SetTabWidth(2, v:false, 2)
autocmd FileType help call SetTabWidth(8, v:true, 2)

function! RetabWidth(type, tab_width)
	" This is necessary to prevent retab from replacing tabs with more tabs.
	execute "setlocal tabstop=" . a:tab_width

	" In visual mode, the change applies to the selected lines. In normal mode,
	" it applies to the entire file.
	if a:type ==# "V"
		execute a:firstline . ',' . a:lastline . 'retab!'
	else
		retab!
	endif

	" Running retab will update tabstop so it must be manually reverted to the
	" previous value. The tabstop value is copied from shiftwidth since retab
	" does not touch that.
	let &l:tabstop = &l:shiftwidth
endfunction

" Define mappings to convert spaces to tabs.
noremap <leader>2 :call RetabWidth(visualmode(), 2)<cr>
noremap <leader>4 :call RetabWidth(visualmode(), 4)<cr>
noremap <leader>8 :call RetabWidth(visualmode(), 8)<cr>

" Define mapping to convert tabs to spaces.
noremap <leader>0 :retab<cr>
