" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
autocmd FileType netrw mapclear <buffer>

" Use t to enter a directory.
function! NetrwBrowse(dest)
	call netrw#LocalBrowseCheck(netrw#Call("NetrwBrowseChgDir", 1, a:dest))
endfunction
function! NetrwReturn()
	call NetrwBrowse(netrw#Call("NetrwGetWord"))
endfunction
autocmd FileType netrw nnoremap <buffer> t :call NetrwReturn()<cr>

" Use p to go up a directory. It can be preceded by a number to go up multiple
" directories.
function! NetrwParent()
	let l:count = v:count
	if l:count == 0
		let l:count = 1
	endif
	let l:path = repeat("../", l:count)

	" Start with <esc> because otherwise 2p would go up 4 directories and 3p
	" would go up 9 directories. I've tried a variety of other simpler
	" techniques and pretty much everything else came with some edge case.
	return "\<esc>:call NetrwBrowse('" . l:path . "')\<cr>"
endfunction
autocmd FileType netrw nnoremap <expr> <buffer> p NetrwParent()

" Define additional keys for navigating to the (r) root directory, the (h) home
" directory, and (w) the current working directory.
autocmd FileType netrw nnoremap <buffer> or :call NetrwBrowse("/")<cr>
autocmd FileType netrw nnoremap <buffer> oh :call NetrwBrowse($HOME)<cr>
autocmd FileType netrw nnoremap <buffer> ow :call NetrwBrowse(getcwd())<cr>

" Map additional functions for creating, renaming, and deleting. This uses M
" instead of m for creating a new directory since Netrw's NetrwBrowseChgDir
" internally uses m for marking and redefining m would break NetrwBrowse().
function! NetrwCreate()
	call netrw#Call("NetrwOpenFile", 1)
endfunction
function! NetrwMkdir()
	call netrw#Call("NetrwMakeDir", "")
endfunction
function! NetrwRename()
	call netrw#Call("NetrwLocalRename", b:netrw_curdir)
endfunction
function! NetrwRemove()
	call netrw#Call("NetrwLocalRm", b:netrw_curdir)
endfunction
autocmd FileType netrw nnoremap <buffer> c :call NetrwCreate()<cr>
autocmd FileType netrw nnoremap <buffer> M :call NetrwMkdir()<cr>
autocmd FileType netrw nnoremap <buffer> r :call NetrwRename()<cr>
autocmd FileType netrw nnoremap <buffer> x :call NetrwRemove()<cr>

" Display file size and modification time in Netrw. Use dot instead of hyphen as
" date separator to make searching easier since hyphen is frequently used in
" dated filenames. For the time being, Vim 9 is excluded due to a bug in how it
" handles long filenames. See https://bit.ly/45Q14gd for details.
if v:version < 900
	let g:netrw_liststyle = 1
	let g:netrw_maxfilenamelen = 40
	let g:netrw_timefmt = "%Y.%m.%d %H:%M:%S %Z"
endif

" Netrw hides line numbers by default. Show relative line numbers in netrw. The
" upstream default includes nobuflisted, which is excluded here so terminal
" works correctly. See https://bit.ly/489Lkoc for details.
let g:netrw_bufsettings = "nomodifiable nomodified number relativenumber nowrap readonly"

" Display directories above files but otherwise sort alphabetically.
let g:netrw_sort_sequence = "[\/]"

" Netrw by default maps gx. Disable mapping so gx can be used to navigate to the
" x character.
let g:netrw_nogx = 1

" Hide the .DS_Store file, .git directory, the current directory, and the parent
" directory. We do not have to exclude .swp files since those are stored in a
" separate directory.
let g:netrw_list_hide = "^\\.DS_Store,\\.git/,^\\./,^\\.\\./"

" Use <leader>e to open Netrw in the current window. Use <leader>E to open Netrw
" in a new tab.
nnoremap <leader>e :Explore<cr>
nnoremap <leader>E :Texplore<cr>
