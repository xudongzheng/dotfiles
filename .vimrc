" Map Colemak keys in alphabetical order.
noremap d g
noremap e k
noremap f e
noremap g t
noremap i l
noremap j y
noremap k n
noremap l u
noremap n j
noremap o p
noremap p r
noremap r s
noremap s d
noremap t f
noremap u i
noremap y o
noremap D G
noremap E K
noremap F E
noremap G T
noremap I L
noremap J Y
noremap K N
noremap L U
noremap N J
noremap O P
noremap P R
noremap R S
noremap S D
noremap T F
noremap U I
noremap Y O

" Use the desert color scheme starting with Vim 9. Use elflord if older.
if v:version >= 900
	colors desert
else
	colors elflord
endif

" Enable syntax highlighting.
syntax on

" Enable plugins and indentation for specific file types.
filetype plugin indent on

" Use space as the leader key.
let mapleader = " "

" Disable timeout for leader key and other mappings. However this timeout should
" not apply to the Esc key. See https://bit.ly/3MsyJW1 for details.
set notimeout
set ttimeout

" Store temporary files in .vim to keep the working directories clean.
set directory=~/.vim/swap
set undodir=~/.vim/undo

" Enable mouse support.
set mouse=a

" Enable persistent undo.
set undofile

" Use incremental search and highlight as we go.
set hlsearch
set incsearch

" Search should be case insensitive unless containing uppercase characters.
set ignorecase
set smartcase

" Reduce screen redraw so macros run more quickly.
set lazyredraw

" Show line numbers as relative so relative navigation is easier. Show actual
" line number for active line.
set relativenumber
set number

" Show line and character number in lower right hand corner.
set ruler

" Only insert a single space after punctuations when using the automatic
" formatter (via dq).
set nojoinspaces

" Increase history for search and command line entries.
set history=10000

" Highlight the active line and the active column.
set cursorline
set cursorcolumn
highlight CursorColumn ctermbg=lightcyan ctermfg=black

" Set the text width to 80 and create a vertical bar in 81st column. Some
" filetypes such as gitcommit have a custom width defined and we use autocmd
" here so our textwidth value takes precedence.
autocmd FileType * setlocal textwidth=80
set colorcolumn=81

" Set scroll offset so the active line stays towards the center.
set scrolloff=8

" Set wildmenu to show options when using tab autocomplete.
set wildmenu

" Have backspace behave as it does in other applications.
if has("patch-8.2.590")
	set backspace=indent,eol,nostop
else
	set backspace=indent,eol,start
endif

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters. Do
" not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" Use :V and :S to create vertical and horizontal split.
command V :Vexplore
command S :Sexplore

" When tmux is used, Vim can't detect that xterm bracketed paste is supported so
" it must be configured manually. This snippet comes from https://bit.ly/3GZcaUG
" and ':help xterm-bracketed-paste'.
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"

" An abbrevation at the end of pasted text gets expanded but it shouldn't be.
" See https://bit.ly/3RGkCwX for Vim issue. Breaking the undo sequence is a
" workaround that stops that though I have no clue why it works.
autocmd OptionSet paste if &paste == 0 | call feedkeys("\<c-g>u") | endif

" Highlight trailing whitespace per https://bit.ly/35RTov2.
func! HighlightTrailingWS()
	highlight ExtraWhitespace ctermbg=red
	match ExtraWhitespace /\s\+$/
endfunc
autocmd BufEnter * call HighlightTrailingWS()

" By default, set the spell checker language to English. Use <leader>l and
" <leader>L to change to Spanish and English respectively. For both, ignore
" Chinese characters.
set spelllang=en,cjk
nnoremap <leader>l :setlocal spelllang=es,cjk<cr>
nnoremap <leader>L :setlocal spelllang=en,cjk<cr>

" Use <leader>s in normal mode to automatically format Go source code.
autocmd FileType go nnoremap <buffer> <leader>s :! gofmt -w=true -s %<cr>:e<cr>

func! MapText()
	" In text files, use <leader>d to insert the date in the American format.
	" This code comes from https://bit.ly/2UWmveA.
	nnoremap <buffer> <leader>d "=strftime('%B %-d, %Y')<cr>p

	" Use <leader>x for checking and unchecking a checkbox.
	nnoremap <leader>x :s/\[x\]/[_]/e<cr>:s/\[ \]/[x]/e<cr>:s/\[_\]/[ ]/e<cr>
endfunc
autocmd FileType markdown,text call MapText()

" Use <leader>c to comment code. This should work in normal mode (for the active
" line) and in visual line mode. We use U instead of I since the :normal command
" accounts for the Colemak mapping. There are obviously many missing filetypes
" and they will be added as needed. While we don't use Groovy directly, we use
" it through Gradle. We have xdefaults for the .Xresources file.
autocmd FileType cfg,cmake,conf,config,crontab,debsources,dockerfile,gdb,gitrebase,kconfig,make,pamconf,perl,python,readline,ruby,sh,sshconfig,sshdconfig,tmux,yaml,zsh noremap <buffer> <leader>c :normal U# <esc>
autocmd FileType arduino,c,cpp,cs,dts,go,groovy,java,javascript,objc,php,scala,swift noremap <buffer> <leader>c :normal U// <esc>
autocmd FileType sql noremap <buffer> <leader>c :normal U-- <esc>
autocmd FileType matlab,tex noremap <buffer> <leader>c :normal U% <esc>
autocmd FileType vim noremap <buffer> <leader>c :normal U" <esc>
autocmd FileType xdefaults noremap <buffer> <leader>c :normal U! <esc>

" Use <leader>c to comment .ssh/known_hosts.
autocmd BufRead known_hosts noremap <buffer> <leader>c :normal U#<esc>

" Define <leader>c for types like HTML and CSS that only support block comments.
" For normal mode, append before prepend to prevent the comment line from being
" wrapped into multiple lines.
autocmd FileType html,svg,xml nnoremap <buffer> <leader>c A --><esc>I<!-- <esc>
autocmd FileType html,svg,xml xnoremap <buffer> <leader>c c<!--<cr>--><esc>P
autocmd FileType css nnoremap <buffer> <leader>c A */<esc>I/* <esc>
autocmd FileType css xnoremap <buffer> <leader>c c/*<cr><bs><bs><bs>*/<esc>P

" In a code file, use <leader>p and <leader>P to print the visually-selected
" variables.
autocmd FileType go xnoremap <buffer> <leader>p y:r! echo "println($RANDOM, )"<cr>==$P
autocmd FileType go xnoremap <buffer> <leader>P y:r! echo "fmt.Println($RANDOM, )"<cr>==$P
autocmd FileType javascript xnoremap <buffer> <leader>p y:r! echo "console.log($RANDOM, )"<cr>==$P
autocmd FileType php xnoremap <buffer> <leader>p y:r! echo "var_dump($RANDOM, );"<cr>==$<left>P
autocmd FileType python,swift xnoremap <buffer> <leader>p y:r! echo "print($RANDOM, )"<cr>==$P
autocmd FileType sh xnoremap <buffer> <leader>p y:r! echo "echo $RANDOM $"<cr>==$p

" When editing a diff file using 'git add -p', use <leader>p to exclude the
" visual selection.
autocmd BufRead addp-hunk-edit.diff xnoremap <buffer> <leader>p :s/^-/ /e<cr>gv:g/^+/d<cr>

func! MapMarkdownSnippets()
	" In Markdown, use <leader><cr>1 through <leader><cr>6 for making a line
	" into a heading.
	nnoremap <buffer> <leader><cr>1 I# <esc>
	nnoremap <buffer> <leader><cr>2 I## <esc>
	nnoremap <buffer> <leader><cr>3 I### <esc>
	nnoremap <buffer> <leader><cr>4 I#### <esc>
	nnoremap <buffer> <leader><cr>5 I##### <esc>
	nnoremap <buffer> <leader><cr>6 I###### <esc>

	" Use <leader><cr>b to make the selected text bold. Use <leader><cr>i for
	" italics.
	xnoremap <buffer> <leader><cr>b c****<esc><left>P
	xnoremap <buffer> <leader><cr>i c**<esc>P

	" Use <leader><cr>l to make the selected text a link.
	xnoremap <buffer> <leader><cr>l c[]<esc>P<right>a()<esc>
endfunc
autocmd FileType markdown call MapMarkdownSnippets()

" When modifying crontab, use <leader>* as a shortcut for defining a cron that
" runs every minute.
autocmd FileType crontab noremap <buffer> <leader>* 5I* <esc>

" In .eml files, \q is used to quote text. Remove mapping since we are already
" using \ to go to the next tab and don't want any delay.
autocmd FileType mail unmap <buffer> \q

" Use <leader>h and <leader>H to simplify git rebase.
autocmd FileType gitrebase xnoremap <buffer> <leader>h :s/pick/squash<cr>
autocmd FileType gitcommit nnoremap <buffer> <leader>h G{kkdgg

" Set tabs to be 4 spaces and use tabs instead of spaces. This uses autocmd to
" override Vim's language-specific configuration. YAML is an exception that uses
" spaces for indentation.
autocmd FileType * setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=0
autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Wrap long line even if the initial line is longer than textwidth. Per
" https://goo.gl/3pws7z, we should not combine flags when removing.
autocmd FileType * setlocal formatoptions-=b formatoptions-=l

" Do not automatically wrap code except in text files, where text is treated as
" code. Automatic wrapping will still occur in comments.
autocmd FileType * setlocal formatoptions-=t
autocmd FileType gitcommit,markdown,tex,text setlocal formatoptions+=t

" Enable autoindent for Markdown and text files. Without this a lot of
" formatting doesn't work correctly such as when using dqap to format a bullet
" list where a bullet item has 3 or more lines.
autocmd FileType markdown,text setlocal autoindent

" Hitting enter on a commented line should not create another comment line. Make
" an exception for CSS since the standard is block comments as opposed to line
" comments in most other languages.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o
autocmd FileType css setlocal formatoptions+=ro

" Use the same word boundary for all file types.
autocmd FileType * set iskeyword=@,48-57,_

" Treat .fs (F#) and .kt (Kotlin) files as Scala files. They are obviously
" different but are similar enough for most of syntax highlighting and
" indentation to work. OCaml is another candidate for F# but it doesn't handle
" braces well.
autocmd BufRead,BufNewFile *.fs,*.kt setlocal filetype=scala

" Treat overlay files for Zephyr/ZMK and ZMK keymap files as DeviceTree.
autocmd BufRead,BufNewFile *.keymap,*.overlay setlocal filetype=dts

" Treat Zephyr defconfig files as regular configuration files.
autocmd BufRead,BufNewFile *_defconfig setlocal filetype=conf

" Set filetype for SSH configuration files that are included from the main file.
autocmd BufRead,BufNewFile ~/.ssh/config-* setlocal filetype=sshconfig

" Treat all unrecognized files as text files.
autocmd BufRead,BufNewFile * if &filetype == "" | setlocal filetype=text | endif

" Enable spell checker automatically for text files. This is done after the
" filetype detection above so they do not get the spell checker enabled. Since
" 'spell' is 'local to window' rather than 'local to buffer', it is necessary to
" use BufRead and BufNewFile instead of FileType. This combination ensures that
" the setting takes effect in every window that opens the buffer. With FileType,
" it would only take effect in the first window that opens the buffer.
func! EnableSpell()
	if index(["gitcommit", "markdown", "tex", "text"], &filetype) >= 0
		setlocal spell
	endif
endfunc
autocmd BufRead,BufNewFile * call EnableSpell()

" Sometimes the spell checker does not work correctly in large TeX files. This
" seems to resolve most of the issue per https://goo.gl/dtuJSk. See
" https://goo.gl/YbxTHp for more information on spell checking in TeX files.
autocmd FileType tex syntax spell toplevel

" Use m to trigger commands in normal mode.
nnoremap m :
xnoremap m :

" Automatically resize splits in the active tab when the window is resized.
" Resize splits when switching to a tab to account for splits in background tabs
" when the window is resized.
autocmd VimResized,TabEnter * wincmd =

" By default, deleting with Ctrl-U and Ctrl-W in insert mode cannot be undone.
" This is not ideal as sometimes these are pressed accidentally. Define mapping
" to allow undoing per https://bit.ly/2ZSlinw.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" In insert mode, Ctrl-Shift-U behaves like Ctrl-U. It's easy to trigger
" accidentally since it's used for Unicode input on Linux. For simplicity, do
" nothing and manually delete the inserted data afterwards.
inoremap <c-s-u> <nop>

" In insert and normal mode, use Ctrl-C to save file. If initially in insert
" mode, this will remain in normal mode at the end. For insert mode, imap is
" necessary instead of inoremap so an abbreviation typed immediately before
" Ctrl-C is correctly expanded.
imap <c-c> <esc>:w<cr>
nnoremap <c-c> :w<cr>

" When pasting over text with o, do not copy the deleted text. See
" https://bit.ly/2Mc0Ac9 for more information. Use O for the default visual
" pasting behavior.
xnoremap o pgvy
xnoremap O p

" Define <leader>o for pasting before the selected text. It works by inserting a
" space before the visual selection, reselecting that, and pasting over the
" temporary space.
xnoremap <leader>o I <esc>1vpgvy

" When selecting until the end of the line, do not include the newline
" character. Otherwise pasting over the selected text would move up the next
" line of text. This selects trailing whitespaces unlike g_.
xnoremap $ $<left>

" Use dh, dn, de, and di to navigate splits.
nnoremap dh <c-w><c-h>
nnoremap dn <c-w><c-j>
nnoremap de <c-w><c-k>
nnoremap di <c-w><c-l>

" Use <F4> to toggle spell checker.
inoremap <F4> <c-o>:setlocal spell!<cr>
nnoremap <F4> :setlocal spell!<cr>

" Use <F5> to refresh a file from disk.
inoremap <F5> <c-o>:e<cr>
nnoremap <F5> :e<cr>

" Use <F6> to wrap/unwrap text.
set nowrap
inoremap <F6> <c-o>:setlocal wrap!<cr>
nnoremap <F6> :setlocal wrap!<cr>

" Use <F10> to show diff since file save.
inoremap <F10> <c-o>:w !diff % -<cr>
nnoremap <F10> :w !diff % -<cr>

" Use <F12> key to unhighlight searched text.
inoremap <F12> <c-o>:noh<cr>
nnoremap <F12> :noh<cr>

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
autocmd FileType netrw mapclear <buffer>

" Define function for calling internal Netrw function. Ideally we would use
" netrw#Call but there is a bug in the implementation per http://bit.ly/2l9fLtd.
" The bug is fixed in Vim 8.1.1715 and we can switch to netrw#Call once the
" patch is included everywhere.
func! NetrwFunction(suffix)
	redir => scriptnames
	silent! scriptnames
	redir END
	for script in split(l:scriptnames, "\n")
		if l:script =~ "netrw.vim"
			return printf("<snr>%d_%s", str2nr(split(l:script, ":")[0]), a:suffix)
		endif
	endfor
endfunc

" Use s to go up a directory and t to enter a directory.
func! NetrwBrowse(dest)
	let NetrwChange = function(NetrwFunction("NetrwBrowseChgDir"))
	call netrw#LocalBrowseCheck(NetrwChange(1, a:dest))
endfunc
func! NetrwReturn()
	let NetrwGetWord = function(NetrwFunction("NetrwGetWord"))
	call NetrwBrowse(NetrwGetWord())
endfunc
autocmd FileType netrw nnoremap <buffer> s :call NetrwBrowse("..")<cr>
autocmd FileType netrw nnoremap <buffer> t :call NetrwReturn()<cr>

" Vim has a hard time when s above is preceded by a number. In Netrw, it only
" works when the preceding number is less than or equal to the number of lines
" between the current line and the end of the Netrw listing (inclusive). Use o
" for going up multiple directories. Typically the number of levels is small and
" the operation will use a right handed key followed by a left handed key.
for i in range(1,9)
	let path = repeat("../", i)
	let cmd = printf('autocmd FileType netrw nnoremap <buffer> o%d :call NetrwBrowse("%s")<cr>', i, path)
	exec cmd
endfor

" Define additional keys for navigating to the (r) root directory, the (h) home
" directory, and (w) the current working directory.
autocmd FileType netrw nnoremap <buffer> or :call NetrwBrowse("/")<cr>
autocmd FileType netrw nnoremap <buffer> oh :call NetrwBrowse($HOME)<cr>
autocmd FileType netrw nnoremap <buffer> ow :call NetrwBrowse(getcwd())<cr>

" Map additional functions for creating, renaming, and deleting. This uses M
" instead of m for creating a new directory since Netrw's NetrwBrowseChgDir
" internally uses m for marking and redefining m would break NetrwBrowse().
func! NetrwCreate()
	let NetrwOpenFile = function(NetrwFunction("NetrwOpenFile"))
	call NetrwOpenFile(1)
endfunc
func! NetrwMkdir()
	let NetrwMakeDir = function(NetrwFunction("NetrwMakeDir"))
	call NetrwMakeDir("")
endfunc
func! NetrwRename()
	let NetrwLocalRename = function(NetrwFunction("NetrwLocalRename"))
	call NetrwLocalRename(b:netrw_curdir)
endfunc
func! NetrwRemove()
	let NetrwLocalRm = function(NetrwFunction("NetrwLocalRm"))
	call NetrwLocalRm(b:netrw_curdir)
endfunc
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

" Netrw hides line numbers by default. Show relative line numbers in netrw.
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"

" Display directories above files but otherwise sort alphabetically.
let g:netrw_sort_sequence = "[\/]"

" Netrw by default maps gx. Disable mapping so gx can be used to navigate to the
" x character.
let g:netrw_nogx = 1

" Hide the .DS_Store file, .git directory, the current directory, and the parent
" directory. We do not have to exclude .swp files since those are stored in a
" separate directory.
let g:netrw_list_hide = "^\\.DS_Store,\\.git/,^\\./,^\\.\\./"

" Use bash syntax for shell scripts.
let g:is_bash = 1

" Treat all .tex files as LaTeX.
let g:tex_flavor = "latex"

" In normal mode, use <leader>q to save Vim session to file and use <leader>Q to
" load Vim session from file. The session file goes in the working directory and
" not the home directory so multiple Vim sessions can be saved and restored.
set sessionoptions=tabpages
func! SaveSession()
	try
		mksession vim-session
		quitall
	endtry
endfunc
nnoremap <leader>q :call SaveSession()<cr>
func! LoadSession()
	source vim-session
	call delete(expand("vim-session"))
endfunc
nnoremap <leader>Q :call LoadSession()<cr>

" In visual mode, use <leader>q and <leader>Q to place the selected text in
" double and single quotes respectively.
xnoremap <leader>q c""<esc>P
xnoremap <leader>Q c''<esc>P

" Use <leader>u to convert from standard base64 encoding to URL base64 encoding.
nnoremap <leader>u :s/+/-/g<cr>:s/\//_/g<cr>

" Use <leader>w to close tab, similar to Ctrl-W in GUI programs.
nnoremap <leader>w :tabclose<cr>

" Use <leader>W to search for trailing whitespace characters.
nnoremap <leader>W /\s\+$<cr>

" Use <leader>f to change case until end of the word.
nnoremap <leader>f ve~

" Use <leader>g to jump to the next Git conflict marker.
nnoremap <leader>g /=======<cr>

" Use <leader>a to sort visually selected lines. Sort by ASCII per
" https://goo.gl/HuZ6KL.
xnoremap <leader>a ! LC_ALL=C sort<cr>

" Use <leader>A to highlight non-ASCII characters.
nnoremap <leader>A /[^\t -~]<cr>

" Use <leader>t to search for triple TODO.
nnoremap <leader>t /TODO TODO<cr>

" Use <leader>z to correct word under cursor to first suggestion.
nnoremap <leader>z z=1<cr><cr>

" Use <leader>b to show the current buffer number.
nnoremap <leader>b :echo bufnr('%')<cr>

" Use <leader>i to make id uppercase.
nnoremap <leader>i :s/id\>/ID/g<cr>

" Use <leader>j to copy to system clipboard. In normal mode, it triggers an
" operator that takes a motion. In visual mode, it handles the selected text.
function! XclipOperator(type)
	" Copy to default register. The first case is for character motion (such as
	" yanking some words), the second is for line motion (such as yanking some
	" lines), and the last is for visual mode.
	if a:type ==# "char"
		execute "normal! `[v`]y"
	elseif a:type ==# "line"
		execute "normal! `[V`]y"
	else
		execute "normal! gvy"
	endif

	" Copy to system clipboard with xclip.
	if executable("xclip")
		call system("xclip -sel clip", getreg('"'))
	elseif executable("pbcopy")
		call system("pbcopy", getreg('"'))
	endif
endfunction
nnoremap <leader>j :set operatorfunc=XclipOperator<cr>g@
xnoremap <leader>j :<c-u>call XclipOperator(visualmode())<cr>

" Use <leader>J to reformat selection with arbitrary width and copy to
" clipboard. This is useful for writing messages in Vim before sending with an
" external application. The operator function does not handle the char type
" since reformatting makes no sense in that context.
function! XclipReformatOperator(type)
	setlocal textwidth=1000
	if a:type ==# "line"
		execute "normal! `[V`]gq"
	else
		execute "normal! gvgqgv"
	endif
	call XclipOperator(a:type)
	setlocal textwidth=80
	if a:type ==# "line"
		execute "normal! `[V`]gq"
	else
		execute "normal! gvgq"
	endif
endfunction
nnoremap <leader>J :set operatorfunc=XclipReformatOperator<cr>g@
xnoremap <leader>J :<c-u>call XclipReformatOperator(visualmode())<cr>

" Use <leader>e to open Netrw in the current window. Use <leader>E to open Netrw
" in a new tab.
nnoremap <leader>e :Explore<cr>
nnoremap <leader>E :Texplore<cr>

" Use <leader>y and <leader>Y to yank respectively the relative and absolute
" file/directory path. This comes from https://bit.ly/2TdYq0O.
nnoremap <leader>y :let @" = expand("%")<cr>
nnoremap <leader>Y :let @" = expand("%:p")<cr>

" Define mappings to convert spaces to tabs. Use <leader>2, <leader>4, and
" <leader>8 for indentation with 2/4/8 spaces respectively. In normal mode, this
" applies to the entire file. In visual mode, this applies to the selected
" lines. Running retab will update tabstop so it must be manually returned to 4.
noremap <leader>2 :retab! 2<cr>:setlocal tabstop=4<cr>
noremap <leader>4 :retab! 4<cr>
noremap <leader>8 :retab! 8<cr>:setlocal tabstop=4<cr>

" Use <leader>$ to go to the last tab.
nnoremap <leader>$ :tablast<cr>

" Use \ to go to next tab and <tab> to go to previous tab.
nnoremap \ :tabn<cr>
nnoremap <tab> :tabp<cr>

" Use <leader>' to convert the surrounding double quotes to single quotes.
" Simiarly use <leader>" to convert from single quotes to double quotes. Both
" use `` to return to the previous cursor location after replacing a quote.
nnoremap <leader>' di"v<left>r'p
nnoremap <leader>" di'v<left>r"p

" Define function to source Vim files relative to this .vimrc.
let s:dotfiles_dir = fnamemodify(expand("<sfile>:h"), ":p")
func! SourceVim(path)
	let l:script_path = s:dotfiles_dir .. a:path
	exec "source " .. l:script_path
endfunc

call SourceVim("vim/abbrev.vim")
call SourceVim("vim/abbrev-c.vim")
call SourceVim("vim/abbrev-go.vim")
