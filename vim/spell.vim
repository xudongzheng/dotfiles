" Use F4 to toggle spell checker.
inoremap <f4> <c-o>:setlocal spell!<cr>
nnoremap <f4> :setlocal spell!<cr>

" By default, set the spell checker language to English. Use <leader>l and
" <leader>L to change to Spanish and English respectively. For both, ignore
" Chinese characters.
set spelllang=en,cjk
nnoremap <leader>l :setlocal spelllang=es,cjk<cr>
nnoremap <leader>L :setlocal spelllang=en,cjk<cr>

" Use <leader>z to correct word under cursor to first suggestion.
nnoremap <leader>z z=1<cr><cr>

" Use <leader>Z to add word under cursor to dictionary.
function! ConfirmSpellAdd()
	let l:word = expand("<cword>")
	if confirm("Add '" . l:word . "' to personal dictionary?", "&Yes\n&No", 2) == 1
		execute "normal! zg"
	endif
endfunction
nnoremap <leader>Z :call ConfirmSpellAdd()<cr>

" Use <leader><space> to reload personal dictionary.
nnoremap <leader><space> :execute "mkspell! " . fnameescape(&l:spellfile)<cr>

" Sometimes the spell checker does not work correctly in large TeX files. This
" seems to resolve most of the issue per https://goo.gl/dtuJSk. See
" https://goo.gl/YbxTHp for more information on spell checking in TeX files.
autocmd FileType tex syntax spell toplevel
