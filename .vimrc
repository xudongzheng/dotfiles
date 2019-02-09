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

" Set the text width to 80 and create a vertical bar in 81st column.
set textwidth=80
set colorcolumn=81

" Set scroll offset so the active line stays towards the center.
set scrolloff=8

" Set wildmenu to show options when using tab autocomplete.
set wildmenu

" Have backspace behave as it does in other applications.
set backspace=2

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters.
set nrformats+=alpha

" Define abbreviation for Go import paths.
func! AbbrevGoImport()
	iab <buffer> tbion "bufio"
	iab <buffer> tbn "bytes"
	iab <buffer> tcn "context"
	iab <buffer> tcsn "crypto/subtle"
	iab <buffer> tcxn "crypto/x509"
	iab <buffer> tdsn "database/sql"
	iab <buffer> tebn "encoding/base64"
	iab <buffer> tecn "encoding/csv"
	iab <buffer> tehn "encoding/hex"
	iab <buffer> tejn "encoding/json"
	iab <buffer> tfcn "fusion/context"
	iab <buffer> tfcrn "fusion/crypto/rand"
	iab <buffer> tfen "fusion/errors"
	iab <buffer> tfgn "fusion/gopher"
	iab <buffer> tfln "fusion/log"
	iab <buffer> tfmtn "fmt"
	iab <buffer> tfn "fusion"
	iab <buffer> tfnhn "fusion/net/http"
	iab <buffer> tion "io"
	iab <buffer> tioun "io/ioutil"
	iab <buffer> tln "log"
	iab <buffer> tmn "math"
	iab <buffer> tnetn "net"
	iab <buffer> tnhn "net/http"
	iab <buffer> tnun "net/url"
	iab <buffer> tosen "os/exec"
	iab <buffer> tosn "os"
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
func! AbbrevGoSnippets()
	iab <buffer> ;t :=
	iab <buffer> bnbn bytes.NewBuffer(nil)
	iab <buffer> bytn Bytes()
	iab <buffer> cctx context.Context
	iab <buffer> cltn Close()
	iab <buffer> cotn Commit()
	iab <buffer> ctxg ctx := context.Get(rw)
	iab <buffer> cvbyte []byte
	iab <buffer> dftn defer func() {<CR><CR>}()<up><bs>
	iab <buffer> drbc defer resp.Body.Close()
	iab <buffer> dtrb defer tx.Rollback()
	iab <buffer> enl err != nil {<CR>log.Fatal(err)<CR>}
	iab <buffer> enr err != nil {<CR>return err<CR>}
	iab <buffer> ent err != nil {<CR>t.Fatal(err)<CR>}
	iab <buffer> enw err != nil {<CR>log.Warn(err)<CR>}
	iab <buffer> erows err = rows.Scan(
	iab <buffer> ertn err.Error()
	iab <buffer> ertw errors.New("TODO TODO TODO wip")
	iab <buffer> fkr for key := range
	iab <buffer> fkvr for key, value := range
	iab <buffer> foid fusion.ObjectID
	iab <buffer> fvr for _, value := range
	iab <buffer> gftn go func() {<CR><CR>}()<up><bs>
	iab <buffer> hdb helper.DB
	iab <buffer> hdbb helper.DB.Begin
	iab <buffer> hdbe helper.DB.Exec
	iab <buffer> hdbq helper.DB.Query
	iab <buffer> hdbqr helper.DB.QueryRow
	iab <buffer> ifce interface{}
	iab <buffer> imtn import (<CR><CR>)<CR><up><up><bs>
	iab <buffer> initn func init() {<CR><CR>}<up><bs>
	iab <buffer> ioeof err == io.EOF
	iab <buffer> iss i++
	iab <buffer> maintn func main() {<CR><CR>}<up><bs>
	iab <buffer> nfoid fusion.NewObjectID()
	iab <buffer> pkgm package main
	iab <buffer> rntn rows.Next()
	iab <buffer> senr err == sql.ErrNoRows
	iab <buffer> strtn String()
	iab <buffer> tnow time.Now()
	iab <buffer> ttm t *testing.M
	iab <buffer> ttt t *testing.T
endfunc
autocmd FileType go call AbbrevGoSnippets()

" Define abbreviations for TeX.
func! AbbrevTeX()
	iab <buffer> beq \begin{equation}
	iab <buffer> deq \end{equation}
	iab <buffer> ber \begin{verbatim}
	iab <buffer> der \end{verbatim}
	iab <buffer> mathbc \mathbb{C}
	iab <buffer> mathbn \mathbb{N}
	iab <buffer> mathbq \mathbb{Q}
	iab <buffer> mathbr \mathbb{R}
	iab <buffer> mathbz \mathbb{Z}
endfunc
autocmd FileType tex call AbbrevTeX()

" Define abbreviations for HTML and XML.
autocmd FileType html,xml iab <buffer> // <!-- --> <left><left><left><left><left>
func! AbbrevHTML()
	iab <buffer> tifn {{if}}<left><left>
	iab <buffer> teln {{else}}
	iab <buffer> tendn {{end}}
endfunc
autocmd FileType html call AbbrevHTML()

" Define miscellaneous abbreviations. For TODO, three works better than two
" since two will always end up on the same line, making it easier to grep.
autocmd FileType javascript iab <buffer> tt ===
iab mtrm <Esc>3a-<Esc>a
iab todo TODO
iab todot TODO TODO TODO

" In .go files, use <Leader>d to show documentation for package at cursor.
func! GoDoc()
	let pkg = substitute(getline("."), "^import", "", "")
	let pkg = substitute(pkg, "[\t ]", "", "")
	let pkg = substitute(pkg, "\"", "", "g")
	tabnew
	exec "read ! go doc " . pkg
	normal dgss
	setlocal nomodified
	setlocal nomodifiable
endfunc
autocmd FileType go nnoremap <Leader>d :call GoDoc()<CR>

" Use <Leader>c to comment code. This should work in normal mode (for the active
" line) and in visual line mode. We use U instead of I since the :normal command
" accounts for the Colemak mapping. There are obviously many missing filetypes
" and they will be added as needed.
autocmd FileType conf,crontab,perl,python,sh,yaml noremap <buffer> <Leader>c :normal U# <Esc>
autocmd FileType c,cs,go,java,javascript noremap <buffer> <Leader>c :normal U// <Esc>
autocmd FileType sql noremap <buffer> <Leader>c :normal U-- <Esc>
autocmd FileType matlab,tex noremap <buffer> <Leader>c :normal U% <Esc>
autocmd FileType vim noremap <buffer> <Leader>c :normal U" <Esc>
autocmd FileType xdefaults noremap <buffer> <Leader>c :normal U! <Esc>

" Define <Leader>c for HTML and XML. For normal mode, append first since
" prepending first may cause the line to be wrapped into multiple lines. Since
" we handle normal and visual mode separately, we do not need to use the :normal
" command and should use the underlying QWERTY mapping. TODO look into multiline
" comments for other languages as well.
autocmd FileType html,xml nnoremap <buffer> <Leader>c A --><Esc>I<!-- <Esc>
autocmd FileType html,xml xnoremap <buffer> <Leader>c c<!--<CR>--><Esc>P

" Use <Leader>p and <Leader>P to print the visually-selected variables.
autocmd FileType go xnoremap <buffer> <Leader>p y:r! echo "println($RANDOM, )"<CR>==$P
autocmd FileType go xnoremap <buffer> <Leader>P y:r! echo "fmt.Println($RANDOM, )"<CR>==$P
autocmd FileType javascript xnoremap <buffer> <Leader>p y:r! echo "console.log($RANDOM, )"<CR>==$P
autocmd FileType php xnoremap <buffer> <Leader>p y:r! echo "var_dump($RANDOM, )"<CR>==$P
autocmd FileType python xnoremap <buffer> <Leader>p y:r! echo "print($RANDOM, )"<CR>==$P
autocmd FileType sh xnoremap <buffer> <Leader>p y:r! echo "echo $RANDOM $"<CR>==$p

" When modifying crontab, use <Leader>* as a shortcut for defining a cron that
" runs every minute.
autocmd FileType crontab noremap <buffer> <Leader>* 5I* <Esc>

" In .eml files, \q is used to quote text. Remove mapping since we are already
" using \ to go to the next tab and don't want any delay.
autocmd FileType mail unmap <buffer> \q

" Use <Leader>s in normal mode to automatically format Go source code.
autocmd FileType go nnoremap <Leader>s :! gofmt -w=true -s %<CR>:e<CR>

" Set tabs to be 4 spaces and use tabs instead of spaces. This uses autocmd so
" we can override language-specific configuration. Python, for example, is
" configured to expand tabs to spaces. YAML is an exception where we want to
" expand tabs to spaces and use 2 spaces for indentation.
autocmd FileType * setlocal noexpandtab shiftwidth=4 tabstop=4
autocmd FileType yaml setlocal expandtab softtabstop=2

" Wrap long line even if the initial line is longer than textwidth.
autocmd FileType * setlocal formatoptions-=l

" Do not automatically wrap code except in text files, where text is treated as
" code. Automatic wrapping will still occur in comments.
autocmd FileType * setlocal formatoptions-=t
autocmd FileType markdown,tex,text setlocal formatoptions+=t

" Hitting enter on a commented line should not create another comment line. Per
" https://goo.gl/3pws7z, we should not combine flags when removing. Make an
" exception for CSS since the standard is block comments as opposed to line
" comments in most other languages.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o
autocmd FileType css setlocal formatoptions+=ro

" Enable spell checker for git commits, TeX, and text files.
autocmd FileType gitcommit,markdown,tex,text setlocal spell

" Sometimes the spell checker does not work correctly in large TeX files. This
" seems to resolve most of the issue per https://goo.gl/dtuJSk. See
" https://goo.gl/YbxTHp for more information on spell checking in TeX files.
autocmd FileType tex syntax spell toplevel

" Treat .fs (F#) and .kt (Kotlin) files as Scala files. They are obviously
" different but are similar enough for most of syntax highlighting and
" indentation to work. OCaml is another candidate for F# though it doesn't
" handle braces well.
autocmd BufRead,BufNewFile *.fs,*.kt setlocal filetype=scala

" Treat .vue files (for Vue.js) as HTML files.
autocmd BufRead,BufNewFile *.vue setlocal filetype=html

" We often use fc to edit bash commands in vim. Treat them as shell scripts.
" Some versions of bash use a hyphen whereas other versions use a dot.
autocmd BufRead bash-fc-*,bash-fc.* setlocal filetype=sh

" Treat all unrecognized files as text files.
autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

" Set smartindent, except for text files. Otherwise in text files, lines that
" start with keywords such as 'do' are indented incorrectly.
autocmd FileType * setlocal smartindent
autocmd FileType markdown,text setlocal nosmartindent autoindent

" Use the enter key to trigger commands in normal mode. Since <CR> is typically
" used to execute a command in the command-line window (accessible via Ctrl-F),
" we will use :x instead.
nnoremap <CR> :
xnoremap <CR> :
autocmd CmdwinEnter * cabbrev <buffer> x <CR>

" Use dh, dn, de, and di to navigate splits.
nnoremap dh <C-W><C-H>
nnoremap dn <C-W><C-J>
nnoremap de <C-W><C-K>
nnoremap di <C-W><C-L>

" Use <F4> to toggle spell checker.
inoremap <F4> <c-o>:set spell!<CR>
nnoremap <F4> :set spell!<CR>

" Use <F5> to refresh a file from disk.
inoremap <F5> <c-o>:e<CR>
nnoremap <F5> :e<CR>

" Use <F6> to wrap/unwrap text.
set nowrap
inoremap <F6> <c-o>:set wrap!<CR>
nnoremap <F6> :set wrap!<CR>

" Use <F9> to toggle paste.
set pastetoggle=<F9>

" Use <F10> to show diff since file save.
inoremap <F10> <c-o>:w !diff % -<CR>
nnoremap <F10> :w !diff % -<CR>

" Use <F12> key to unhighlight searched text.
inoremap <F12> <c-o>:noh<CR>
nnoremap <F12> :noh<CR>

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

" Netrw hides line numbers by default. Show relative line numbers in netrw.
let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"

" Display directories above files but otherwise sort alphabetically.
let g:netrw_sort_sequence="[\/]$"

" Hide the .DS_Store file, .git directory, the current directory, and the parent
" directory. We do not have to exclude .swp files since those are stored in a
" separate directory.
let g:netrw_list_hide = "^\\.DS_Store,\\.git/,^\\./,^\\.\\./"

" Use bash syntax for shell scripts.
let g:is_bash = 1

" Treat all .tex files as LaTeX.
let g:tex_flavor = "latex"

" Use <Leader>4 to convert from standard base64 encoding to URL base64 encoding.
" Reserve <Leader>6 for conversion in the other direction though we don't really
" think it will be necessary.
nnoremap <Leader>4 :s/+/-/g<CR>:s/\//_/g<CR>

" Use <Leader>w to adjusts splits to be even.
nnoremap <Leader>w <C-W>=

" Use <Leader>f to change case until end of the word.
nnoremap <Leader>f ve~

" Use <Leader>g to jump to the next Git conflict marker.
nnoremap <Leader>g /=======<CR>

" Use <Leader>a to sort visually selected lines. Sort by ASCII per
" https://goo.gl/HuZ6KL.
xnoremap <Leader>a ! LC_ALL=C sort<CR>

" Use <Leader>A to highlight non-ASCII characters.
nnoremap <Leader>A /[^\x00-\x7F]<CR>

" Use <Leader>t to search for triple TODO.
nnoremap <Leader>t /TODO TODO<CR>

" Use <Leader>z to correct word under cursor to first suggestion.
nnoremap <Leader>z z=1<CR><CR>

" Use <Leader>b to show the current buffer number.
nnoremap <Leader>b :echo bufnr('%')<CR>

" Use <Leader>h and <Leader>H to simplify git rebase.
autocmd FileType gitrebase xnoremap <Leader>h :s/pick/squash<CR>
autocmd FileType gitcommit nnoremap <Leader>h G{kkdgg

" Use <Leader>i to make id uppercase.
nnoremap <Leader>i :s/id\>/ID/g<CR>

" Use <Leader>m to open netrw in new tab.
nnoremap <Leader>m :Te<CR>

" Use <Leader>l and <Leader>u to set the spell language to English and Spanish
" respectively.
nnoremap <Leader>l :set spelllang=en<CR>
nnoremap <Leader>u :set spelllang=es<CR>

" Use \ to go to next tab and <tab> to go to previous tab.
nnoremap \ :tabn<CR>
nnoremap <Tab> :tabp<CR>

" TODO beta: enable code folding per https://goo.gl/PJLbbF.
set foldmethod=syntax
set foldlevel=99
