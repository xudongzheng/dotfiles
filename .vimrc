" Define path to dotfiles directory, which is needed for numerous scripts.
let g:dotfiles_dir = fnamemodify(expand("<sfile>:h"), ":p")

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

" Set Escape key timeout. This is necessary for IME integration to ensure that
" the keyboard layout reverts to Colemak quickly after upon leaving insert mode.
set ttimeoutlen=10

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

" Define helper function for cnoremap. Use cnoremap instead of command when the
" command needs to be in a different format.
function! IsCommandNotSearch()
	return getcmdpos() == 1 && getcmdtype() == ':'
endfunction

" Use :N to count the number of occurrences in a file.
cnoremap <expr> N (IsCommandNotSearch() ? "%s///ign<left><left><left><left><left>" : "N")

" Use :H to open a help page in a new tab. This uses cnoremap instead of command
" so tab autocompletion works.
cnoremap <expr> H (IsCommandNotSearch() ? "tab help " : "H")

" Use :G for grep and :I for grep inverse. Using :g and :v with /d is confusing
" to reason about.
cnoremap <expr> G (IsCommandNotSearch() ? "v//d<left><left>" : "G")
cnoremap <expr> I (IsCommandNotSearch() ? "g//d<left><left>" : "I")

" Enable line number for help pages. Additionally, set conceallevel so concealed
" characters do not break CursorColumn.
autocmd FileType help setlocal number relativenumber conceallevel=0

" If the file is standard input, allow it to close without a warning even if it
" wasn't saved.
autocmd StdinReadPost * setlocal buftype=nofile

" Set the text width to 80 and create a vertical bar in 81st column. Some file
" types such as gitcommit have a custom width defined and we use autocmd here to
" override it.
autocmd FileType * setlocal textwidth=80
set colorcolumn=81

" Vim displays the Git commit summary line in a different color. Set width for
" consistency with above.
if has("patch-9.0.2189")
	let g:gitcommit_summary_length = 80
endif

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

" Allow h/i and left/right arrow keys to wrap from one line to another.
set whichwrap+=<,>,h,l,[,]

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

" Use :F to format a text file, save, and close. The command should not do
" anything if executed from a non-text file.
function! FormatMarkdown()
	if IsTextFileType(&filetype)
		execute "%! python3 " . g:dotfiles_dir . "python/format_md.py" | x
	else
		echoerr "Unable to format non-text file"
	endif
endfunction
command F call FormatMarkdown()

" Define :E for opening a file or directory.
function! OpenPath(path)
	" If path contains a colon, discard everything after it. This makes it
	" possible to double click a path in grep output (assuming it does not
	" contain spaces) and open it quickly.
	let l:path = split(a:path, ":")[0]

	" If path is an absolute path, open directly. Otherwise, resolve it relative
	" to the open file or directory. This is often preferred over using :e
	" directly, which resolves paths relative to the working directory.
	if l:path[0] == "/"
		execute "e" fnameescape(l:path)
	else
		let l:dir = expand("%:p:h")
		execute "e" fnameescape(fnamemodify(l:dir . "/" . l:path, ":p"))
	endif
endfunction
command -nargs=1 E call OpenPath(<q-args>)

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

" Use <leader>W to delete trailing spaces/tabs. In normal mode, it's applied to
" the entire file. In visual mode, it's only applied to the selected lines.
nnoremap <leader>W :%s/[ \t]\+$//<cr>
xnoremap <leader>W :s/[ \t]\+$//<cr>

" Use <leader>y and <leader>Y to add a blank line below and above but remain in
" normal mode.
nnoremap <leader>y o<esc>
nnoremap <leader>Y O<esc>

" A standalone period is often used as a placeholder when writing. Use <leader>.
" to go to the next placeholder. The search should match a period at the start
" of a new line or in the middle of a line following a space.
nnoremap <leader>. /\(^\.\\| \zs\.\ze\)<cr>

" Use <leader><space> to replace %20 with a whitespace character. This is useful
" for working with screenshot URLs copied from Firefox.
xnoremap <leader><space> :s/%20/ /g<cr>

" In normal mode, use <leader>/ and <leader>? to search in 'very nomagic` mode.
" This allows characters regularly used for regular expressions to be searched
" without escaping.
nnoremap <leader>/ /\V
nnoremap <leader>? ?\V

" In visual mode, use <leader>/ and <leader>? to search the selected text. This
" is based on https://bit.ly/3KU5Dgf. The selection is first yanked to the
" default register. In 'very nomagic' mode, the search character and backslash
" still need escaping.
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
	setfiletype diff

	" Delete empty first line.
	1delete

	" Allow buffer to be closed without saving.
	setlocal buftype=nofile
endfunction
autocmd FileType gitcommit nnoremap <buffer> <leader>d :call GitCommitDiff()<cr>

" Use <leader>D to duplicate the buffer into a new scratch buffer tab.
function! DuplicateBuffer()
	execute "normal! ggVGy"
	execute "tabnew"
	execute "normal! Vp"
	setlocal buftype=nofile
endfunction
nnoremap <leader>D :call DuplicateBuffer()<cr>

" Use <leader>S to create a new scratch buffer tab.
function! CreateScratchBuffer()
	execute "tabnew"
	setlocal buftype=nofile
endfunction
nnoremap <leader>S :call CreateScratchBuffer()<cr>

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

" Wrap long line even if the initial line is longer than textwidth. Per
" https://goo.gl/3pws7z, we should not combine flags when removing.
autocmd FileType * setlocal formatoptions-=b formatoptions-=l

" Do not automatically wrap code except in text files, where text is treated as
" code. Automatic wrapping will still occur in comments.
autocmd FileType * setlocal formatoptions-=t
autocmd FileType gitcommit,markdown,rst,tex,text setlocal formatoptions+=t

" Hitting enter on a commented line should not create another comment line. Make
" an exception for CSS since the standard is block comments as opposed to line
" comments in most other languages.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o
autocmd FileType css setlocal formatoptions+=ro

" Use the same word boundary for all file types.
autocmd FileType * set iskeyword=@,48-57,_

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

" Use F5 to refresh a file or directory from disk. Skip if Vim is used as a
" pager or if the buffer is not associated with a file.
function! RefreshBuffer()
	if &l:buftype == "" && expand("%:p") != ""
		edit
	endif
endfunction
nnoremap <f5> :call RefreshBuffer()<cr>

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

" Use <leader>u in normal mode to convert various Unicode characters to ASCII.
function! ConvertUnicode()
	%s/[\u2013\u2014]/-/ge
	%s/[\u2018\u2019]/'/ge
	%s/[\u201c\u201d]/"/ge
endfunction
nnoremap <leader>u :call ConvertUnicode()<cr>

" Use <leader>u in visual mode to run text through uniq. Use <leader>U to count.
xnoremap <leader>u ! uniq<cr>
xnoremap <leader>U ! uniq -c<cr>

" Use <leader>w to close tab, similar to Ctrl-W in GUI programs.
nnoremap <leader>w :tabclose<cr>

" Use <leader>f to change case until end of the word.
nnoremap <leader>f ve~

" Use <leader>g to jump to the next Git conflict marker.
nnoremap <leader>g /^=======$<cr>

" Use <leader>a in normal mode to select everything.
nnoremap <leader>a ggVG

" Use <leader>A in normal mode to highlight non-ASCII characters.
nnoremap <leader>A /[^\t -~]<cr>

" Use <leader>a in visual mode to sort the selected lines. By default, sort
" using binary per https://goo.gl/HuZ6KL. Use <leader>A to sort with en_US,
" which is useful for case-insensitive sorting.
xnoremap <leader>a ! LC_ALL=C.UTF-8 sort -n<cr>
xnoremap <leader>A ! LC_ALL=en_US.UTF-8 sort -n<cr>

" Use <leader>r to reverse visually selected lines.
xnoremap <leader>r ! tac<cr>

" Use <leader>R to sort randomly.
xnoremap <leader>R ! sort -R<cr>

" Use <leader>t to search for triple TODO.
nnoremap <leader>t /TODO TODO<cr>

" Use <leader>z to correct word under cursor to first suggestion.
nnoremap <leader>z z=1<cr><cr>

" Use <leader>b to show the current buffer number.
nnoremap <leader>b :echo bufnr("%")<cr>

" Define mappings to convert spaces to tabs. In normal mode, this applies to the
" entire file. In visual mode, this applies to the selected lines. Running retab
" will update tabstop so it must be manually reverted to the previous value. The
" tabstop value is copied from shiftwidth since retab does not touch that.
noremap <leader>2 :retab! 2<cr>:let &l:tabstop=&l:shiftwidth<cr>
noremap <leader>4 :retab! 4<cr>:let &l:tabstop=&l:shiftwidth<cr>
noremap <leader>8 :retab! 8<cr>:let &l:tabstop=&l:shiftwidth<cr>

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

function! SourceVim(path)
	let l:script_path = g:dotfiles_dir . a:path
	execute "source " . l:script_path
endfunction

call SourceVim("vim/abbrev.vim")
call SourceVim("vim/abbrev_c.vim")
call SourceVim("vim/abbrev_go.vim")
call SourceVim("vim/abbrev_md.vim")
call SourceVim("vim/clipboard.vim")
call SourceVim("vim/comment.vim")
call SourceVim("vim/filetype.vim")
call SourceVim("vim/ime.vim")
call SourceVim("vim/netrw.vim")
call SourceVim("vim/pager.vim")
call SourceVim("vim/termdebug.vim")
if has("patch-8.1.1401")
	call SourceVim("vim/terminal.vim")
endif
call SourceVim("vim/text_object.vim")
