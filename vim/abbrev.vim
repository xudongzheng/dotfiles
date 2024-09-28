" Define abbreviations for Bash snippets.
function! AbbrevBashSnippets()
	iab <buffer> ift if [[ ]]; then<cr>fi<esc><up>4<right>u
	iab <buffer> elift elif [[ ]]; then<esc>8<left>u
endfunction
autocmd FileType bash call AbbrevBashSnippets()

" Define abbreviations for PHP snippets.
function! AbbrevPHPSnippets()
	iab <buffer> dietn die();
endfunction
autocmd FileType php call AbbrevPHPSnippets()

" Define abbreviations for Python snippets.
function! AbbrevPythonSnippets()
	xnoremap <leader>l clen()<esc>P
endfunction
autocmd FileType python call AbbrevPythonSnippets()

" Many languages use toString() to convert to string.
autocmd FileType java,javascript,scala iab <buffer> strtn toString()

" Swift uses String() to convert integer to string.
autocmd FileType swift xnoremap <leader>s cString()<esc>P

" Define abbreviations for TeX snippets.
function! AbbrevTeXSnippets()
	iab <buffer> beq \begin{equation}
	iab <buffer> deq \end{equation}
	iab <buffer> ber \begin{verbatim}
	iab <buffer> der \end{verbatim}
	iab <buffer> mbc \mathbb{C}
	iab <buffer> mbn \mathbb{N}
	iab <buffer> mbq \mathbb{Q}
	iab <buffer> mbr \mathbb{R}
	iab <buffer> mbz \mathbb{Z}
	iab <buffer> infty \infty
	iab <buffer> ninfty -\infty
endfunction
autocmd FileType tex call AbbrevTeXSnippets()

" Define abbreviations for HTML and XML. Many of the HTML abbreviations are for
" working with Go templates.
function! AbbrevHTMLSnippets()
	iab <buffer> tdotn {{.}}
	iab <buffer> tdotx {{.}}<left><left>
	iab <buffer> teln {{else}}
	iab <buffer> tendn {{end}}
	iab <buffer> tifn {{if}}<left><left>
	iab <buffer> trn {{range}}<left><left>
endfunction
autocmd FileType html call AbbrevHTMLSnippets()

" Define abbreviations for comments in various languages.
autocmd FileType css iab <buffer> // /* */<left><left><left>
autocmd FileType html,svg,xml iab <buffer> // <!-- --><left><left><left><left>
autocmd FileType sql iab <buffer> // --

" Define abbreviations for == and !=. In JavaScript, this should be === and !==.
" Handle HTML and Vue like JavaScript since since they may contain JavaScript.
autocmd FileType * iab <buffer> tt ==
autocmd FileType * iab <buffer> rt !=
autocmd FileType html,javascript,vue iab <buffer> tt ===
autocmd FileType html,javascript,vue iab <buffer> rt !==

" Define abbreviations for integer incrementation, which is the same in most
" languages.
autocmd FileType * iab <buffer> iss i++
autocmd FileType * iab <buffer> jss j++
autocmd FileType * iab <buffer> kss k++

" Define to do abbreviations. Three is better than two since two will always end
" up on the same line, making it easier to grep.
iab trt TODO TODO TODO
iab tst TODO

" Define abbreviations for quotes.
iab dq ""
iab sq ''
