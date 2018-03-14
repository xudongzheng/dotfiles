" Map Colemak keys to QWERTY keys (in alphabetical order).
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

" Use the elflord color scheme.
colors elflord

" Enable syntax highlighting.
syntax on

" Enable plugins and indentation for specific file types.
filetype plugin indent on

" Use <Space> as the leader key.
let mapleader = " "

" Set vim temporary directories to keep working directories clean. We expect the
" tmp directory to be at the same level as the dot directory containing these
" dot files (checked out from GitHub).
let s:parent = expand("<sfile>:h:h")
let &backupdir = s:parent . "/tmp/vim/backup"
let &directory = s:parent . "/tmp/vim/swap"
let &undodir = s:parent . "/tmp/vim/undo"

" Enable mouse support.
set mouse=a

" Allow Vim to use all 256 colors.
" set t_Co=256

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

" Highlight the active line and the active column.
set cursorline
set cursorcolumn
highlight CursorColumn ctermbg=235

" Set the text width to 80 and create a vertical bar in 81st column.
set textwidth=80
set colorcolumn=81

" Set scroll offset so the active line stays towards the center.
set scrolloff=8

" Set wildmenu to show options when using tab autocomplete.
set wildmenu

" Have backspace behave as it does in other applications.
set backspace=2

" Define abbreviation for Go import paths.
func AbbrevGoImport()
	iab <buffer> tbn "bytes"
	iab <buffer> tdsn "database/sql"
	iab <buffer> tfcn "fusion/context"
	iab <buffer> tfen "fusion/errors"
	iab <buffer> tfln "fusion/log"
	iab <buffer> tfmtn "fmt"
	iab <buffer> tfn "fusion"
	iab <buffer> tfnhn "fusion/net/http"
	iab <buffer> tion "io"
	iab <buffer> tioun "io/ioutil"
	iab <buffer> tmn "math"
	iab <buffer> tnetn "net"
	iab <buffer> tnhn "net/http"
	iab <buffer> tnun "net/url"
	iab <buffer> tosn "os"
	iab <buffer> tosen "os/exec"
	iab <buffer> tpfn "path/filepath"
	iab <buffer> tpn "path"
	iab <buffer> tren "regexp"
	iab <buffer> tscn "strconv"
	iab <buffer> tsn "strings"
	iab <buffer> ttestn "testing"
	iab <buffer> ttn "time"
endfunc
autocmd FileType go call AbbrevGoImport()

" Define abbreviation for Go snippets.
func AbbrevGoSnippets()
	iab <buffer> bnbn bytes.NewBuffer(nil)
	iab <buffer> cctx context.Context
	iab <buffer> closetn Close()
	iab <buffer> committn Commit()
	iab <buffer> ctxg ctx := context.Get(rw)
	iab <buffer> cvbyte []byte
	iab <buffer> enl err != nil {<CR>log.Fatal(err)<CR>}
	iab <buffer> enlw err != nil {<CR>log.Warn(err)<CR>}
	iab <buffer> enr err != nil {<CR>return err<CR>}
	iab <buffer> ent err != nil {<CR>t.Fatal(err)<CR>}
	iab <buffer> errtn err.Error()
	iab <buffer> foid fusion.ObjectID
	iab <buffer> hdb helper.DB
	iab <buffer> hdbb helper.DB.Begin
	iab <buffer> hdbe helper.DB.Exec
	iab <buffer> hdbq helper.DB.Query
	iab <buffer> hdbqr helper.DB.QueryRow
	iab <buffer> imtn import (<return><return>)<return><up><up><bs>
	iab <buffer> initn func init() {<return><return>}<up><bs>
	iab <buffer> ioeof io.EOF
	iab <buffer> maintn func main() {<return><return>}<up><bs>
	iab <buffer> nexttn Next()
	iab <buffer> nfoid fusion.NewObjectID()
	iab <buffer> pkgm package main
	iab <buffer> senr sql.ErrNoRows
	iab <buffer> stringtn String()
	iab <buffer> tnow time.Now()
	iab <buffer> ttm t *testing.M
	iab <buffer> ttt t *testing.T
endfunc
autocmd FileType go call AbbrevGoSnippets()

" Define abbreviations for TeX.
func AbbrevTeX()
	iab <buffer> beq \begin{equation}
	iab <buffer> deq \end{equation}
	iab <buffer> mathbn \mathbb{N}
	iab <buffer> mathbq \mathbb{Q}
	iab <buffer> mathbr \mathbb{R}
endfunc
autocmd FileType tex call AbbrevTeX()

" Define miscellaneous abbreviations. Three works better than two since at least
" two will end up on the same line, making it easier to grep.
iab todo TODO
iab todot TODO TODO TODO

" Set tabs to be 4 spaces and use tabs instead of spaces. This uses autocmd so
" we can override language-specific configuration. Python, for example, is
" configured to expand tabs to spaces. YAML is the only exception where we want
" to expand tabs to spaces.
autocmd FileType * setlocal noexpandtab shiftwidth=4 tabstop=4
autocmd FileType yaml setlocal expandtab softtabstop=4

" Do not automatically wrap code except in TeX where standard text is code.
autocmd FileType * setlocal formatoptions-=t
autocmd FileType tex setlocal formatoptions+=t

" Enable spell checker for git commits and TeX.
autocmd FileType gitcommit,tex setlocal spell

" Treat .kt (Kotlin) files as Scala files. They are obviously different but are
" similar enough for the features such as syntax highlighting to work correctly.
autocmd BufRead,BufNewFile {*.kt} setlocal filetype=scala

" Treat .vue files (for Vue.js) as HTML files.
autocmd BufRead,BufNewFile {*.vue} setlocal filetype=html

" Treat all unrecognized files as text files.
autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

" Set smartindent, except for text files. Otherwise in text files, lines that
" start with keywords such as 'do' are indented incorrectly.
autocmd FileType * setlocal smartindent
autocmd FileType markdown,text setlocal nosmartindent autoindent

" Use backspace to trigger commands in normal mode. In the command line window,
" use :w to execute the active line as a command.
nnoremap <CR> :
xnoremap <CR> :
autocmd CmdwinEnter * cabbrev <buffer> w <CR>

" Use dh, dn, de, and di to navigate splits.
nnoremap dh <C-W><C-H>
nnoremap dn <C-W><C-J>
nnoremap de <C-W><C-K>
nnoremap di <C-W><C-L>

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

" When pasting text, do not overwrite register.
xnoremap o pgvy

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
autocmd FileType netrw mapclear <buffer>

" Use d to go up a directory and f to enter a directory. NetrwFunction borrows
" code from https://goo.gl/LP4pww.
func NetrwFunction(suffix)
	redir => scriptnames
	silent! scriptnames
	redir END
	for script in split(l:scriptnames, "\n")
		if l:script =~ "netrw.vim"
			return printf("<SNR>%d_%s", str2nr(split(l:script, ":")[0]), a:suffix)
		endif
	endfor
endfunc
func NetrwBrowse(dest)
	let NetrwChange = function(NetrwFunction("NetrwBrowseChgDir"))
	call netrw#LocalBrowseCheck(NetrwChange(1, a:dest))
endfunc
func NetrwReturn()
	let NetrwGetWord = function(NetrwFunction("NetrwGetWord"))
	call NetrwBrowse(NetrwGetWord())
endfunc
func NetrwParent()
	call NetrwBrowse("..")
endfunc
autocmd FileType netrw nnoremap <buffer> t :call NetrwReturn()<CR>
autocmd FileType netrw nnoremap <buffer> s :call NetrwParent()<CR>

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
autocmd FileType netrw nnoremap <buffer> c :call NetrwCreate()<CR>
autocmd FileType netrw nnoremap <buffer> dm :call NetrwMkdir()<CR>
autocmd FileType netrw nnoremap <buffer> r :call NetrwRename()<CR>
autocmd FileType netrw nnoremap <buffer> x :call NetrwRemove()<CR>

" Display file modification time in netrw browser.
let g:netrw_liststyle = 1

" Netrw hides line numbers by default. Show line numbers in netrw.
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro"

" Use bash syntax for shell scripts.
let g:is_bash = 1

" Use <Leader>4 to convert from standard base64 encoding to URL base64 encoding.
" Reserve <Leader>6 for the other direction though we don't really see it to be
" necessary.
nnoremap <Leader>4 :s/+/-/g<return>:s/\//_/g<return>

" Use <Leader>a to sort visually selected lines.
xnoremap <Leader>a ! sort<return>

" Use <Leader>s in normal mode to automatically format Go source code.
nnoremap <Leader>s :! gofmt -w=true %<return>:e<return>

" Use <Leader>t to search for triple TODO.
nnoremap <Leader>t /TODO TODO<return>

" Use <Leader>h and <Leader>H to simplify git rebase.
autocmd FileType gitrebase xnoremap <Leader>h :s/pick/squash<return>
autocmd FileType gitrebase nnoremap <Leader>H G{kkdgg

" Use <Leader>i to make id uppercase.
nnoremap <Leader>i :s/id\>/ID/g<return>

" Use <Leader>m to open netrw in new tab.
nnoremap <Leader>m :Te<return>

" Use <Leader>w to adjusts splits to be even.
nnoremap <Leader>w <C-W>=

" Use <Leader>l and <Leader>u to set the spell language to English and Spanish
" respectively.
nnoremap <Leader>l :set spelllang=en<return>
nnoremap <Leader>u :set spelllang=es<return>

" Use \ to go to next tab and <tab> to go to previous tab.
nnoremap \ :tabn<return>
nnoremap <Tab> :tabp<return>

" beta stuff

nnoremap <Leader>f ve~
let g:netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"
