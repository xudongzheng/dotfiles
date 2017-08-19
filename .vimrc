" Use the elflord color scheme.
colors elflord

" Enable syntax highlighting.
syntax on

" Enable plugins and indentation for specific file types.
filetype plugin indent on

" Use <Space> as the leader key.
let mapleader = " "

" Use langmap to map colemak keys to qwerty keys in normal mode.
set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP

" Set vim temporary directories to keep working directories clean.
set backupdir=~/tmp/vim/backup
set directory=~/tmp/vim/swap
set undodir=~/tmp/vim/undo

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

" Highlight current line. and create a vertical column in 81st column.
set cursorline
set colorcolumn=81

" Set scroll offset so current line stays towards the center.
set scrolloff=8

" Set wildmenu to show options when using tab autocomplete.
set wildmenu

" Have backspace behave as it does in other applications.
set backspace=2

" Define abbreviation for Go packages.
ab tdsn "database/sql"
ab tfcn "fusion/context"
ab tfen "fusion/errors"
ab tfln "fusion/log"
ab tfmtn "fmt"
ab tfn "fusion"
ab tfnhn "fusion/net/http"
ab tion "io"
ab tnhn "net/http"
ab tosn "os"

" Define abbreviation for Go snippets.
ab cctx context.Context
ab closetn Close()
ab ctxg ctx := context.Get(rw)
ab enl err != nil {<CR>log.Fatal(err)<CR>}
ab enr err != nil {<CR>return err<CR>}
ab ent err != nil {<CR>t.Fatal(err)<CR>}
ab errortn Error()
ab foid fusion.ObjectID
ab hdb helper.DB
ab hdbb helper.DB.Begin
ab hdbe helper.DB.Exec
ab hdbq helper.DB.Query
ab hdbqr helper.DB.QueryRow
ab nfoid fusion.NewObjectID()
ab senr sql.ErrNoRows
ab stringtn String()

" Define miscellaneous abbreviations. Three works better than two since at least
" two will end up on the same line, making it easier to grep.
ab todo TODO
ab todot TODO TODO TODO

" Set tabs to be 4 spaces and use tabs instead of spaces. This uses autocmd so
" it does not get overwritten language-specific configuration. Python, for
" example, is configured to expand tabs to spaces. Set text width to 80 for all
" formats except HTML. Enable spell checker for writing git commits.
autocmd FileType * setlocal noexpandtab
autocmd FileType * setlocal shiftwidth=4
autocmd FileType * setlocal tabstop=4
autocmd FileType * setlocal textwidth=80
autocmd FileType html setlocal textwidth=0
autocmd FileType gitcommit setlocal spell

" Vim assumes .md files are modula2 files, but treat them as regular text files.
autocmd BufRead,BufNewFile {*.md} set filetype=text

" Treat .vue files (for Vue.js) as HTML files.
autocmd BufRead,BufNewFile {*.vue} set filetype=html

" Set smartindent, except for text files. Otherwise in text files, lines that
" start with keywords such as 'do' are indented incorrectly.
set smartindent
autocmd FileType text setlocal nosmartindent
autocmd FileType text setlocal autoindent

" Use backspace to trigger commands in normal mode. In the command line window,
" use :w to execute the active line as a command.
nnoremap <CR> :
xnoremap <CR> :
autocmd CmdwinEnter * cabbrev <buffer> w <CR>

" Use gh, gj, gk, and gl to navigate splits.
nnoremap gj <C-W><C-J>
nnoremap gk <C-W><C-K>
nnoremap gl <C-W><C-L>
nnoremap gh <C-W><C-H>

" Use <F4> to toggle spell checker.
inoremap <F4> <c-o>:set spell!<return>
nnoremap <F4> :set spell!<return>

" Use <F5> to refresh a file from disk.
inoremap <F5> <c-o>:e<return>
nnoremap <F5> :e<return>

" Use <F6> to wrap/unwrap text.
set nowrap
inoremap <F6> <c-o>:set wrap!<return>
nnoremap <F6> :set wrap!<return>

" Use <F9> to toggle paste.
set pastetoggle=<F9>

" Use <F10> to show diff since file save.
inoremap <F10> <c-o>:w !diff % -<return>
nnoremap <F10> :w !diff % -<return>

" Use <F12> key to unhighlight searched text.
inoremap <F12> <c-o>:noh<return>
nnoremap <F12> :noh<return>

" When pasting text, do not overwrite register. Note the original mapping (on
" QWERTY layouts) maps to pgvy.
xnoremap p odvj

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
autocmd FileType netrw mapclear <buffer>

" Use d to go up a directory and f to enter a directory. NetrwFunction borrows
" code from https://goo.gl/LP4pww.
func! NetrwFunction(suffix)
	redir => scriptnames
	silent! scriptnames
	redir END
	for script in split(l:scriptnames, "\n")
		if l:script =~ "netrw.vim"
			return printf("<SNR>%d_%s", str2nr(split(l:script, ":")[0]), a:suffix)
		endif
	endfor
endfunc
func! NetrwBrowse(dest)
	let NetrwChange = function(NetrwFunction("NetrwBrowseChgDir"))
	call netrw#LocalBrowseCheck(NetrwChange(1, a:dest))
endfunc
func! NetrwReturn()
	let NetrwGetWord = function(NetrwFunction("NetrwGetWord"))
	call NetrwBrowse(NetrwGetWord())
endfunc
func! NetrwParent()
	call NetrwBrowse("..")
endfunc
autocmd FileType netrw nmap <buffer> f :call NetrwReturn()<CR>
autocmd FileType netrw nmap <buffer> d :call NetrwParent()<CR>

" Map additional functions for creating, renaming, and deleting.
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
autocmd FileType netrw nmap <buffer> c :call NetrwCreate()<CR>
autocmd FileType netrw nmap <buffer> g :call NetrwMkdir()<CR>
autocmd FileType netrw nmap <buffer> s :call NetrwRename()<CR>
autocmd FileType netrw nmap <buffer> x :call NetrwRemove()<CR>

" Display file modification time in netrw browser.
let g:netrw_liststyle = 1

" Netrw hides line numbers by default. Show line numbers in netrw.
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro"

" Use bash syntax for shell scripts.
let g:is_bash = 1

" Use <Leader>d in normal mode to automatically format Go source code.
nnoremap <Leader>d :! gofmt -w=true %<return>:e<return>

" Use <Leader>l to make id uppercase.
nnoremap <Leader>l :s/id\>/ID/g<return>
xnoremap <Leader>l :s/id\>/ID/g<return>

" Use <Leader>m to open netrw in new tab.
nnoremap <Leader>m :Te<return>

" Use <Leader>w to adjusts splits to be even.
nnoremap <Leader>w <C-W>=

" Use \ to go to next tab and <tab> to go to previous tab.
nnoremap \ :tabn<return>
nnoremap <Tab> :tabp<return>

" beta stuff

xnoremap gh :s/pick/squash<return>
let g:netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"
