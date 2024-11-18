let g:mac_ime_bin = g:dotfiles_dir . "vim/mac_ime"

" Track whether Chinese IME was active when last leaving insert mode.
let g:chinese_active = v:false

function! ImActivateFunc(active)
	if a:active
		" If Chinese was last used in insert mode, reenable Chinese IME.
		if g:chinese_active
			call system(g:mac_ime_bin . " com.apple.inputmethod.SCIM.Shuangpin")
		endif
	else
		" Remember if Chinese IME is active when leaving insert mode. Switch
		" back to Colemak layout if necessary.
		let l:ime = system(g:mac_ime_bin)
		if l:ime =~ "^com.apple.inputmethod.SCIM.Shuangpin"
			let g:chinese_active = v:true
			call system(g:mac_ime_bin . " com.apple.keylayout.Colemak")
		else
			let g:chinese_active = v:false
		endif
	endif
endfunction
set imactivatefunc=ImActivateFunc
