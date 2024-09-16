" Map Colemak keys in alphabetical order.
noremap d g
noremap e gk
noremap f e
noremap g t
noremap i l
noremap j y
noremap k n
noremap l u
noremap n gj
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

" Use the desert color scheme starting with Vim 9. Use elflord if older and
" slate in vimdiff since highlighted lines are hard to see in elflord.
if has("patch-9.0.0")
	colorscheme desert
else
	if &diff
		colorscheme slate
	else
		colorscheme elflord
	endif
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

" Store temporary files in .vim to keep the working directories clean. The
" double trailing slash is so that the swap filename is constructed using the
" full file path.
set directory=~/.vim/swap//
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

" Highlight the active line and the active column. The CursorLine color chosen
" here is a bit more prominent than the default.
set cursorline
set cursorcolumn
highlight CursorColumn ctermbg=lightcyan ctermfg=black

" Use :H to open a help page in a new tab. This uses cnoremap instead of command
" so tab autocompletion works. Use getcmdtype() to ensure replacement doesn't
" happen when searching.
cnoremap <expr> H (getcmdpos() == 1 && getcmdtype() == ':' ? "tab help" : "H")

" Enable line number for help pages. Additionally, set conceallevel so concealed
" characters do not break CursorColumn.
autocmd FileType help setlocal number relativenumber conceallevel=0

" If the file is standard input, allow it to close without a warning even if it
" wasn't saved.
autocmd StdinReadPost * setlocal buftype=nofile

" Set the text width to 80 and create a vertical bar in 81st column. Some
" filetypes such as gitcommit have a custom width defined and we use autocmd
" here so our textwidth value takes precedence.
autocmd FileType * setlocal textwidth=80
set colorcolumn=81

" Vim displays the Git commit summary line in a different color. Set width for
" consistency with above.
let g:gitcommit_summary_length = 80

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

" Allow Vim to automatically select regular expression engine. For some reason,
" it defaults to the old engine on macOS. This is necessary for syntax
" highlighting to work correctly in reStructuredText files. See
" https://bit.ly/4bO02mF for details.
set regexpengine=0

" Always show status line regardless of the number of windows.
set laststatus=2

" When running in binary mode (with -b flag), make EOL characters visible. Tabs
" should be displayed normally.
if &binary
	set listchars=tab:\ \ ,eol:$
	set list
endif

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters. Do
" not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" Use :V and :S to create vertical and horizontal split.
command V :Vexplore
command S :Sexplore

" Define :E to open a file. Anything after the colon is discarded. This makes it
" easy to double click a path in grep output (assuming it does not contain
" spaces) and open it..
command -nargs=1 E execute "e" fnameescape(split(<q-args>, ":")[0])

" Define commands for grep and grep inverse. Using :g and :v with /d is
" confusing to reason about.
command -nargs=1 G execute "v/" . <q-args> . "/d"
command -nargs=1 Gi execute "g/" . <q-args> . "/d"

" When tmux is used, Vim can't detect that xterm bracketed paste is supported so
" it must be configured manually. This snippet comes from https://bit.ly/3GZcaUG
" and ':help xterm-bracketed-paste'.
if has("patch-8.1.1401")
	let &t_BE = "\e[?2004h"
	let &t_BD = "\e[?2004l"
	let &t_PS = "\e[200~"
	let &t_PE = "\e[201~"
endif

" An abbrevation at the end of pasted text gets expanded but it shouldn't be.
" See https://bit.ly/3RGkCwX for Vim issue. Breaking the undo sequence is a
" workaround that stops that though I have no clue why it works.
autocmd OptionSet paste if &paste == 0 && mode() == "i" | call feedkeys("\<c-g>u") | endif

" Highlight trailing whitespace per https://bit.ly/35RTov2.
function! HighlightTrailingWS()
	highlight ExtraWhitespace ctermbg=red
	match ExtraWhitespace /\s\+$/
endfunction
autocmd BufEnter * call HighlightTrailingWS()

" Use <leader>W to delete trailing spaces. In normal mode, it's applied to the
" entire file. In visual mode, it's only applied to the selected lines.
nnoremap <leader>W :%s/ \+$//<cr>
xnoremap <leader>W :s/ \+$//<cr>

" Use <leader>y and <leader>Y to add a blank line below and above but remain in
" normal mode.
nnoremap <leader>y o<esc>
nnoremap <leader>Y O<esc>

" A standalone period is often used as a placeholder when writing. Use <leader>.
" to go to the next placeholder. The search should match a period at the start
" of a new line or in the middle of a line following a space.
nnoremap <leader>. /\(^\.\\| \zs\.\ze\)<cr>

" In normal mode, use <leader>/ to search without changing the search pattern.
" This is useful in Netrw for locating a file before continuing the previous
" search.
nnoremap <leader>/ :keeppatterns /

" Use <leader><space> to replace %20 with a whitespace character. This is useful
" for working with screenshot URLs copied from Firefox.
xnoremap <leader><space> :s/%20/ /g<cr>

" Define visual mode mapping to search the selected text. This is based on
" https://bit.ly/3KU5Dgf. The selection is first yanked to the default register.
" Use \V to enable 'very nomagic' searching so special characters are searched
" as is. The search character and backslash still need special escaping.
vnoremap <leader>/ y/\V<c-r>=escape(@",'/\')<cr><cr>
vnoremap <leader>? y?\V<c-r>=escape(@",'?\')<cr><cr>

" By default, set the spell checker language to English. Use <leader>l and
" <leader>L to change to Spanish and English respectively. For both, ignore
" Chinese characters.
set spelllang=en,cjk
nnoremap <leader>l :setlocal spelllang=es,cjk<cr>
nnoremap <leader>L :setlocal spelllang=en,cjk<cr>

" Use <leader>s in normal mode to automatically format Go source code.
autocmd FileType go nnoremap <buffer> <leader>s :! gofmt -w=true -s %<cr>:e<cr>

function! MapText()
	" In text files, use <leader>d to insert the date in the American format.
	" This code comes from https://bit.ly/2UWmveA.
	nnoremap <buffer> <leader>d "=strftime("%B %-d, %Y")<cr>p

	" Use <leader>c for checking and unchecking a checkbox.
	nnoremap <buffer> <leader>c :s/\[x\]/[_]/e<cr>:s/\[ \]/[x]/e<cr>:s/\[_\]/[ ]/e<cr>
endfunction
autocmd FileType markdown,text call MapText()

" Use <leader>c to comment code. This should work in normal mode (for the active
" line) and in visual line mode. We use U instead of I since the :normal command
" accounts for the Colemak mapping. There are obviously many missing filetypes
" and they will be added as needed. While we don't use Groovy directly, we use
" it through Gradle. We have xdefaults for the .Xresources file.
autocmd FileType bash,cfg,cmake,conf,config,crontab,debsources,dockerfile,dosini,gdb,gitconfig,gitrebase,kconfig,make,pamconf,perl,python,readline,ruby,sshconfig,sshdconfig,tmux,yaml noremap <buffer> <leader>c :normal U# <esc>
autocmd FileType arduino,c,cpp,cs,dts,go,groovy,java,javascript,objc,php,scala,swift,typescript noremap <buffer> <leader>c :normal U// <esc>
autocmd FileType sql noremap <buffer> <leader>c :normal U-- <esc>
autocmd FileType matlab,tex noremap <buffer> <leader>c :normal U% <esc>
autocmd FileType vim noremap <buffer> <leader>c :normal U" <esc>
autocmd FileType xdefaults noremap <buffer> <leader>c :normal U! <esc>
autocmd FileType bindzone noremap <buffer> <leader>c :normal U; <esc>

" Define <leader>c for types like HTML and CSS that only support block comments.
" For normal mode, append before prepend to prevent the comment line from being
" wrapped into multiple lines.
autocmd FileType html,svg,xml nnoremap <buffer> <leader>c A --><esc>I<!-- <esc>
autocmd FileType html,svg,xml xnoremap <buffer> <leader>c c<!--<cr>--><esc>P
autocmd FileType css nnoremap <buffer> <leader>c A */<esc>I/* <esc>
autocmd FileType css xnoremap <buffer> <leader>c c/*<cr><bs><bs><bs>*/<esc>P

" In a code file, use <leader>p and <leader>P to add a print statement with a
" random number. In visual mode, the selected variables are printed as well.
function! AppendPrint(tpl, visual, separator)
	" If in visual mode, include selected variable names.
	if a:visual
		normal! gvy
		let l:varnames = a:separator . getreg('"')
	else
		let l:varnames = ""
	endif

	" Generate random 4 digit number.
	let l:randnum = 1000 + rand() % 9000

	" Construct line and add to file.
	execute "normal! o" . printf(a:tpl, l:randnum, l:varnames) . "\<esc>"
endfunction
function! DefinePrint(types, leader, tpl, separator)
	execute "autocmd FileType " . a:types . " nnoremap <buffer> <leader>" . a:leader . ' :call AppendPrint("' . a:tpl . '", v:false, "' . a:separator . '")<cr>'
	execute "autocmd FileType " . a:types . " vnoremap <buffer> <leader>" . a:leader . ' :call AppendPrint("' . a:tpl . '", v:true, "' . a:separator . '")<cr>'
endfunction
call DefinePrint("go", "p", "println(%d%s)", ", ")
call DefinePrint("go", "P", "fmt.Println(%d%s)", ", ")
call DefinePrint("javascript,typescript,vue", "p", "console.log(%d%s)", ", ")
call DefinePrint("php", "p", "var_dump(%d%s);", ", ")
call DefinePrint("python,swift", "p", "print(%d%s)", ", ")
call DefinePrint("python,swift", "p", "print(%d%s)", ", ")
call DefinePrint("bash", "p", "echo %d%s", " $")

" When editing a diff file using 'git add -p', use <leader>p to exclude the
" visual selection.
autocmd BufRead addp-hunk-edit.diff xnoremap <buffer> <leader>p :s/^-/ /e<cr>gv:g/^+/d<cr>

function! MapMarkdownSnippets()
	" In Markdown, use <leader><cr>1 through <leader><cr>6 for making a line
	" into a heading.
	nnoremap <buffer> <leader><cr>1 I# <esc>
	nnoremap <buffer> <leader><cr>2 I## <esc>
	nnoremap <buffer> <leader><cr>3 I### <esc>
	nnoremap <buffer> <leader><cr>4 I#### <esc>
	nnoremap <buffer> <leader><cr>5 I##### <esc>
	nnoremap <buffer> <leader><cr>6 I###### <esc>

	" Use <leader><c-b> to make the selected text bold. Use <leader><c-i> for
	" italics.
	xnoremap <buffer> <leader><c-b> c****<esc><left>P
	xnoremap <buffer> <leader><c-i> c**<esc>P

	" Use <leader><c-l> to make the selected text a link.
	xnoremap <buffer> <leader><c-l> c[]<esc>P<right>a()<esc>
endfunction
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

" Use <leader>d to display the staged diff when writing a commit message.
function! GitCommitDiff()
	" Load diff in a split.
	if winwidth(0) > 160
		vnew
	else
		new
	endif
	read ! git diff --cached
	setlocal filetype=diff

	" Delete empty first line.
	1delete

	" Allow buffer to be closed without saving.
	setlocal buftype=nofile
endfunction
autocmd FileType gitcommit nnoremap <buffer> <leader>d :call GitCommitDiff()<cr>

function! EnableCopilot()
	" Skip if file is for editing shell command.
	if match(expand("%:p"), "^/tmp/bash-fc") == 0 || match(expand("%:p"), "^/private/tmp/") == 0
		return
	endif

	" Enable Copilot plugin if it exists.
	if isdirectory(expand("~/.vim/pack/github/opt/copilot.vim"))
		" Use Ctrl-N instead of Tab for accepting the Copilot suggestion.
		let g:copilot_no_tab_map = v:true
		inoremap <expr> <c-n> copilot#Accept("")

		packadd copilot.vim
	endif
endfunction
autocmd VimEnter * call EnableCopilot()

" Define function for set tab settings.
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
		execute "setlocal shiftwidth=" . a:tab_width
		execute "setlocal tabstop=" . a:tab_width
	else
		setlocal expandtab
		execute "setlocal shiftwidth=" . a:tab_width
		execute "setlocal tabstop=" . a:tab_width
		execute "setlocal softtabstop=" . a:tab_width
	endif
endfunction

" Define tab settings. By default, use tabs for indentation (priority 0).
" VimEnter is included alongside the buffer events so tab width is set when
" reading from standard input. Projects can override the tab width with priority
" 1. Files (such as YAML) can override project settings with priority 2.
autocmd BufRead,BufNewFile,VimEnter * call SetTabWidth(4, v:true, 0)
autocmd FileType yaml call SetTabWidth(2, v:false, 2)

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

" Use Bash syntax for shell scripts.
if has("patch-8.2.2434")
	autocmd FileType sh,zsh setlocal filetype=bash
else
	let g:is_bash = 1
endif

" Treat .fs (F#) and .kt (Kotlin) files as Scala files. They are obviously
" different but are similar enough for most of syntax highlighting and
" indentation to work. OCaml is another candidate for F# but it doesn't handle
" braces well.
if has("patch-9.0.1908")
	autocmd BufRead,BufNewFile *.fs setlocal filetype=scala
else
	autocmd BufRead,BufNewFile *.fs,*.kt setlocal filetype=scala
endif

" Treat Zephyr overlay files and ZMK keymap files as DeviceTree.
autocmd BufRead,BufNewFile *.keymap,*.overlay setlocal filetype=dts

" Treat Zephyr config files as regular configuration files.
autocmd BufRead,BufNewFile .config,*_defconfig setlocal filetype=conf

" Set filetype for SSH configuration files that are included from the main file.
autocmd BufRead,BufNewFile ~/.ssh/config-* setlocal filetype=sshconfig

" Set filetype for SSH known_hosts so <leader>c can be used to comment lines.
autocmd BufRead,BufNewFile ~/.ssh/known_hosts setlocal filetype=conf

" Treat all unrecognized files as text files.
autocmd BufRead,BufNewFile * if &filetype == "" | setlocal filetype=text | endif

" Enable spell checker automatically for text files. This is done after the
" filetype detection above so they do not get the spell checker enabled. Since
" 'spell' is 'local to window' rather than 'local to buffer', it is necessary to
" use BufRead and BufNewFile instead of FileType. This combination ensures that
" the setting takes effect in every window that opens the buffer. With FileType,
" it would only take effect in the first window that opens the buffer.
function! EnableSpell()
	if index(["gitcommit", "markdown", "tex", "text"], &filetype) >= 0
		setlocal spell
	endif
endfunction
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

" Use Ctrl-A and Ctrl-E for home and end in insert and command mode.
inoremap <c-a> <home>
inoremap <c-e> <end>
cnoremap <c-a> <home>
cnoremap <c-e> <end>

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

" Use F4 to toggle spell checker.
inoremap <f4> <c-o>:setlocal spell!<cr>
nnoremap <f4> :setlocal spell!<cr>

" Use F5 to refresh a file from disk.
inoremap <f5> <c-o>:e<cr>
nnoremap <f5> :e<cr>

" Use F6 to wrap/unwrap text.
set nowrap
inoremap <f6> <c-o>:setlocal wrap!<cr>
nnoremap <f6> :setlocal wrap!<cr>

" Use F10 to show diff since file save.
inoremap <f10> <c-o>:w !diff % -<cr>
nnoremap <f10> :w !diff % -<cr>

" Use F12 key to unhighlight searched text.
inoremap <f12> <c-o>:noh<cr>
nnoremap <f12> :noh<cr>

" Treat all .tex files as LaTeX.
let g:tex_flavor = "latex"

" Kconfig syntax highlighting breaks in large files. See https://bit.ly/4dahHWI
" for details.
if !has("patch-9.1.608")
	let g:kconfig_syntax_heavy = v:true
endif

" Use <leader>q to save Vim session to file and use <leader>Q to load Vim
" session from file. All session files are stored in ~/.vim/session so it's easy
" to enumerate every session that can be restored. The session file is deleted
" if unable to quit Vim due to unsaved open files.
set sessionoptions=tabpages
function! GetSessionFile()
	let l:session_file = substitute(getcwd(), "/", "_", "g")
	return expand("~/.vim/session/" . l:session_file)
endfunction
function! SaveSession()
	try
		execute "mksession " . GetSessionFile()
		try
			silent quitall
		catch
			call delete(GetSessionFile())
			echoerr "Unable to quit Vim with unsaved files"
		endtry
	endtry
endfunction
nnoremap <leader>q :call SaveSession()<cr>
function! LoadSession()
	try
		execute "source " . GetSessionFile()
		call delete(GetSessionFile())
	endtry
endfunction
nnoremap <leader>Q :call LoadSession()<cr>

" In visual mode, use <leader>q and <leader>Q to place the selected text in
" double and single quotes respectively.
xnoremap <leader>q c""<esc>P
xnoremap <leader>Q c''<esc>P

" Use <leader>u to convert Unicode single and double quotes to ASCII.
nnoremap <leader>u :%s/[\u2018\u2019]/'/ge<cr>:%s/[\u201c\u201d]/"/ge<cr>

" Use <leader>w to close tab, similar to Ctrl-W in GUI programs.
nnoremap <leader>w :tabclose<cr>

" Use <leader>f to change case until end of the word.
nnoremap <leader>f ve~

" Use <leader>g to jump to the next Git conflict marker.
nnoremap <leader>g /=======<cr>

" Use <leader>a in normal mode to select everything.
nnoremap <leader>a ggVG

" Use <leader>A in normal mode to highlight non-ASCII characters.
nnoremap <leader>A /[^\t -~]<cr>

" Use <leader>a in visual mode to sort the selected lines. By default, sort
" using binary per https://goo.gl/HuZ6KL. Use <leader>A to sort with en_US,
" which is useful for case-insensitive sorting.
xnoremap <leader>a ! LC_ALL=C sort<cr>
xnoremap <leader>A ! LC_ALL=en_US.UTF-8 sort<cr>

" Use <leader>r to reverse visually selected lines.
xnoremap <leader>r ! tac<cr>

" Use <leader>t to search for triple TODO.
nnoremap <leader>t /TODO TODO<cr>

" Use <leader>z to correct word under cursor to first suggestion.
nnoremap <leader>z z=1<cr><cr>

" Use <leader>b to show the current buffer number.
nnoremap <leader>b :echo bufnr("%")<cr>

" Use <leader>i to make id uppercase.
nnoremap <leader>i :s/id\>/ID/g<cr>

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
" Similarly use <leader>" to convert from single quotes to double quotes. Both
" use `` to return to the previous cursor location after replacing a quote.
nnoremap <leader>' di"v<left>r'p
nnoremap <leader>" di'v<left>r"p

" Define function to source Vim files relative to this .vimrc.
let g:dotfiles_dir = fnamemodify(expand("<sfile>:h"), ":p")
function! SourceVim(path)
	let l:script_path = g:dotfiles_dir . a:path
	execute "source " . l:script_path
endfunction

call SourceVim("vim/abbrev-c.vim")
call SourceVim("vim/abbrev-go.vim")
call SourceVim("vim/abbrev.vim")
call SourceVim("vim/clipboard.vim")
call SourceVim("vim/netrw.vim")
if has("patch-8.1.1401")
	call SourceVim("vim/terminal.vim")
endif
call SourceVim("vim/text-object.vim")
