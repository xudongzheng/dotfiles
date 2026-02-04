" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
autocmd FileType netrw mapclear <buffer>

" Use t to enter a directory.
function! NetrwBrowse(dest)
	if has("patch-9.1.846")
		call netrw#LocalBrowseCheck(netrw#Call("NetrwBrowseChgDir", v:true, a:dest, 0))
	else
		call netrw#LocalBrowseCheck(netrw#Call("NetrwBrowseChgDir", v:true, a:dest))
	endif
endfunction
function! NetrwReturn()
	" When the cursor is in the banner area, the Netrw default behavior should
	" be skipped. Navigate if cursor is within file listing area.
	if getline(".")[0] != '"'
		call NetrwBrowse(netrw#Call("NetrwGetWord"))
	endif
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
	call netrw#Call("NetrwOpenFile", v:true)
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

" Display filename with size and modification time in Netrw.
let g:netrw_liststyle = 1

function! SetNetrwTabWidth()
	" The file type must be checked to avoid modifying the tab width for a file
	" that's been opened.
	if &filetype ==# "netrw"
		call SetTabWidth(8, v:true, 2)
	endif
endfunction

function! SetNetrwMaxLen(delta)
	let g:netrw_maxfilenamelen += a:delta
	call NetrwBrowse("")
endfunction

" The size and time format will differ slightly based on the Vim version. For
" the date, use dot instead of hyphen as separator to make searching easier
" since hyphen is often found in filenames.
if has("patch-9.0.2121")
	let g:netrw_maxfilenamelen = 38
	let g:netrw_timefmt = "%Y.%m.%dT%H:%M:%S%z"
elseif has("patch-9.0.0")
	" This subset of Vim has a slight issue with alignment. It's necessary to
	" insert \t and align manually.
	let g:netrw_timefmt = "\t%Y.%m.%dT%H:%M:%S%z"

	" Display size in human format so there's minimal variance from line to
	" line. It can be up to 5 characters plus a space. Files with size 9999 for
	" example are rounded to 10.0k.
	let g:netrw_sizestyle = "H"
	if has("patch-9.0.1991")
		let g:netrw_maxfilenamelen = 47
	else
		let g:netrw_maxfilenamelen = 48
	endif

	" Netrw sets the tab width each time a directory is loaded. The tab width
	" must be overwritten using a timer.
	autocmd FileType netrw call timer_start(0, { -> SetNetrwTabWidth() })

	" By default, Netrw refreshes the listing on FocusGained. That causes the
	" tab width being set and reset all over again. Disable automatic refresh.
	autocmd FileType netrw autocmd! AuNetrwEvent FocusGained *

	" Netrw doesn't correctly display names that exceed the maximum length.
	" Define mapping for temporarily changing the maximum. See
	" https://bit.ly/45Q14gd for details.
	autocmd FileType netrw nnoremap <buffer> + :call SetNetrwMaxLen(8)<cr>
	autocmd FileType netrw nnoremap <buffer> - :call SetNetrwMaxLen(-8)<cr>
else
	let g:netrw_maxfilenamelen = 39
	let g:netrw_timefmt = "%Y.%m.%dT%H:%M:%S%z"
endif

" Netrw hides line numbers by default. Show relative line numbers in netrw. The
" upstream default includes nobuflisted, which is excluded here so terminal
" works correctly. See https://bit.ly/489Lkoc for details.
let g:netrw_bufsettings = "nomodifiable nomodified number relativenumber nowrap readonly"

" Display directories above files but otherwise sort alphabetically.
let g:netrw_sort_sequence = "[\/]"

" Define mapping to change sort order.
autocmd FileType netrw nnoremap <buffer> s :call netrw#Call("NetrwSortStyle", 1)<cr>

" Netrw by default maps gx. Disable mapping so gx can be used to navigate to the
" x character.
let g:netrw_nogx = v:true

" Hide the .DS_Store file, .git directory, the current directory, and the parent
" directory. We do not have to exclude .swp files since those are stored in a
" separate directory.
let g:netrw_list_hide = "^\\.DS_Store,^\\.git/,^\\./,^\\.\\./"

" In normal mode, use <leader>e to open Netrw in the current window. Use
" <leader>E to open Netrw in a new tab.
nnoremap <leader>e :Explore<cr>
nnoremap <leader>E :Texplore<cr>

" In visual mode, use <leader>e to open the selected text as a file or directory
" in a new tab. Anything after the colon is discarded like the :E command.
vnoremap <leader>e y:execute "tabnew " . fnameescape(split(@", ":")[0])<cr>
