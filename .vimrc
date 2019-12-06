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

" Use space as the leader key. Some articles such as https://bit.ly/2on9Qlu
" advocate for setting a local leader rather than limiting a map to a buffer.
" I've decided against doing that since I don't run any plugins and don't need
" the additional complexity.
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

" Allow Ctrl-A and Ctrl-X to increment and decrement alphabetical characters. Do
" not treat numbers that begin with 0 as octal.
set nrformats+=alpha nrformats-=octal

" Define abbreviation for Go import paths.
func! AbbrevGoImport()
	iab <buffer> tbion "bufio"
	iab <buffer> tbn "bytes"
	iab <buffer> tcn "context"
	iab <buffer> tcsn "crypto/subtle"
	iab <buffer> tcxn "crypto/x509"
	iab <buffer> tdsn "database/sql"
	iab <buffer> tebin "encoding/binary"
	iab <buffer> tebn "encoding/base64"
	iab <buffer> tecn "encoding/csv"
	iab <buffer> tehn "encoding/hex"
	iab <buffer> tejn "encoding/json"
	iab <buffer> tepn "encoding/pem"
	iab <buffer> tfcn "fusion/context"
	iab <buffer> tfcrn "fusion/crypto/rand"
	iab <buffer> tfen "fusion/errors"
	iab <buffer> tfgn "fusion/gopher"
	iab <buffer> tfln "fusion/log"
	iab <buffer> tfmtn "fmt"
	iab <buffer> tfn "fusion"
	iab <buffer> tfnhn "fusion/net/http"
	iab <buffer> thtn "html/template"
	iab <buffer> tion "io"
	iab <buffer> tioun "io/ioutil"
	iab <buffer> tln "log"
	iab <buffer> tmn "math"
	iab <buffer> tnen "net"
	iab <buffer> tnhn "net/http"
	iab <buffer> tnsn "net/smtp"
	iab <buffer> tntn "net/textproto"
	iab <buffer> tnun "net/url"
	iab <buffer> tosen "os/exec"
	iab <buffer> tosn "os"
	iab <buffer> tpfn "path/filepath"
	iab <buffer> tpn "path"
	iab <buffer> tren "regexp"
	iab <buffer> trfn "reflect"
	iab <buffer> tscn "strconv"
	iab <buffer> tsn "strings"
	iab <buffer> tsyn "sync"
	iab <buffer> ttestn "testing"
	iab <buffer> ttn "time"
	iab <buffer> tttn "text/template"
	iab <buffer> tuun "unicode/utf8"
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
	iab <buffer> dcc defer conn.Close()
	iab <buffer> dfc defer f.Close()
	iab <buffer> dftn defer func() {<cr><cr>}()<up><bs>
	iab <buffer> drbc defer resp.Body.Close()
	iab <buffer> dtrb defer tx.Rollback()
	iab <buffer> enl err != nil {<cr>log.Fatal(err)<cr>}
	iab <buffer> enr err != nil {<cr>return err<cr>}
	iab <buffer> ent err != nil {<cr>t.Fatal(err)<cr>}
	iab <buffer> enw err != nil {<cr>log.Warn(err)<cr>}
	iab <buffer> erows err = rows.Scan(
	iab <buffer> ertn err.Error()
	iab <buffer> ertw errors.New("TODO TODO TODO wip")
	iab <buffer> fkr for key := range
	iab <buffer> fkvr for key, value := range
	iab <buffer> foid fusion.ObjectID
	iab <buffer> fvr for _, value := range
	iab <buffer> gftn go func() {<cr><cr>}()<up><bs>
	iab <buffer> hdb helper.DB
	iab <buffer> hdbb helper.DB.Begin
	iab <buffer> hdbe helper.DB.Exec
	iab <buffer> hdbq helper.DB.Query
	iab <buffer> hdbqr helper.DB.QueryRow
	iab <buffer> ifce interface{}
	iab <buffer> imc import "C"
	iab <buffer> imtn import (<cr><cr>)<cr><up><up><bs>
	iab <buffer> initn func init() {<cr><cr>}<up><bs>
	iab <buffer> ioeof err == io.EOF
	iab <buffer> ior io.Reader
	iab <buffer> iow io.Writer
	iab <buffer> iss i++
	iab <buffer> maintn func main() {<cr><cr>}<up><bs>
	iab <buffer> netcn net.Conn
	iab <buffer> netip net.IP
	iab <buffer> nfoid fusion.NewObjectID()
	iab <buffer> pkgm package main
	iab <buffer> rntn rows.Next()
	iab <buffer> senr err == sql.ErrNoRows
	iab <buffer> strtn String()
	iab <buffer> tdur time.Duration
	iab <buffer> tnow time.Now()
	iab <buffer> ttime time.Time
	iab <buffer> ttm t *testing.M
	iab <buffer> ttt t *testing.T
	iab <buffer> utctn UTC()
endfunc
autocmd FileType go call AbbrevGoSnippets()

" Define mapping for common Go snippets.
func! MapGoSnippets()
	xnoremap <leader>b c[]byte()<esc>P
	xnoremap <leader>l clen()<esc>P
	xnoremap <leader>s cstring()<esc>P
endfunc
autocmd FileType go call MapGoSnippets()

autocmd FileType go call AbbrevGoSnippets()
" Define abbreviations for TeX.
func! AbbrevTeX()
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
endfunc
autocmd FileType tex call AbbrevTeX()

" Define abbreviations for HTML and XML. Many of the HTML abbreviations are for
" working with Go templates.
autocmd FileType html,xml iab <buffer> // <!-- --><left><left><left><left>
func! AbbrevHTML()
	iab <buffer> tdotn {{.}}
	iab <buffer> teln {{else}}
	iab <buffer> tendn {{end}}
	iab <buffer> tifn {{if}}<left><left>
	iab <buffer> trn {{range}}<left><left>
endfunc
autocmd FileType html call AbbrevHTML()

" Define miscellaneous abbreviations. For TODO, three works better than two
" since two will always end up on the same line, making it easier to grep.
autocmd FileType c,cpp iab <buffer> maintn int main() {<cr><cr>}<up><bs>
autocmd FileType javascript iab <buffer> tt ===
autocmd FileType go,sh iab <buffer> countk COUNT(*)
iab mtrm <esc>3a-<esc>a
iab tst TODO
iab trt TODO TODO TODO

" In .go files, use <leader>d to show documentation for package at cursor.
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
autocmd FileType go nnoremap <buffer> <leader>d :call GoDoc()<cr>

" Use <leader>s in normal mode to automatically format Go source code.
autocmd FileType go nnoremap <buffer> <leader>s :! gofmt -w=true -s %<cr>:e<cr>

func! MapText()
	" In text files, use <leader>d to insert the date in the American format.
	" This code comes from https://bit.ly/2UWmveA. Use <leader>D for the time
	" and <leader><cr>d for the time in parenthesis.
	nnoremap <buffer> <leader>d "=strftime('%B %-d, %Y')<cr>p
	nnoremap <buffer> <leader>D "=strftime('%H:%M')<cr>p
	nnoremap <buffer> <leader><cr>d "=strftime('(%H:%M)')<cr>p

	" Use <leader>x for checking a checkbox and <leader>X for unchecking. The
	" latter uses s instead of r so the line doesn't end with a space, which
	" would trigger an error with 'git diff --check'.
	nnoremap <buffer> <leader>x ^t]rx
	nnoremap <buffer> <leader>X ^t]s <esc>
endfunc
autocmd FileType markdown,text call MapText()

" Use <leader>c to comment code. This should work in normal mode (for the active
" line) and in visual line mode. We use U instead of I since the :normal command
" accounts for the Colemak mapping. There are obviously many missing filetypes
" and they will be added as needed.
autocmd FileType conf,crontab,perl,python,readline,ruby,sh,sshconfig,tmux,yaml noremap <buffer> <leader>c :normal U# <esc>
autocmd FileType arduino,c,cpp,cs,go,java,javascript,php,scala noremap <buffer> <leader>c :normal U// <esc>
autocmd FileType sql noremap <buffer> <leader>c :normal U-- <esc>
autocmd FileType matlab,tex noremap <buffer> <leader>c :normal U% <esc>
autocmd FileType vim noremap <buffer> <leader>c :normal U" <esc>
autocmd FileType xdefaults noremap <buffer> <leader>c :normal U! <esc>

" Use <leader>c to comment .ssh/known_hosts.
autocmd BufRead known_hosts noremap <buffer> <leader>c :normal U#<esc>

" Define <leader>c for HTML and XML. For normal mode, append first since
" prepending first may cause the line to be wrapped into multiple lines. Since
" we handle normal and visual mode separately, we do not need to use the :normal
" command and should use the underlying QWERTY mapping. TODO look into multiline
" comments for other languages as well.
autocmd FileType html,xml nnoremap <buffer> <leader>c A --><esc>I<!-- <esc>
autocmd FileType html,xml xnoremap <buffer> <leader>c c<!--<cr>--><esc>P

" Use <leader>p and <leader>P to print the visually-selected variables.
autocmd FileType go xnoremap <buffer> <leader>p y:r! echo "println($RANDOM, )"<cr>==$P
autocmd FileType go xnoremap <buffer> <leader>P y:r! echo "fmt.Println($RANDOM, )"<cr>==$P
autocmd FileType javascript xnoremap <buffer> <leader>p y:r! echo "console.log($RANDOM, )"<cr>==$P
autocmd FileType php xnoremap <buffer> <leader>p y:r! echo "var_dump($RANDOM, );"<cr>==$<left>P
autocmd FileType python xnoremap <buffer> <leader>p y:r! echo "print($RANDOM, )"<cr>==$P
autocmd FileType sh xnoremap <buffer> <leader>p y:r! echo "echo $RANDOM $"<cr>==$p

func! HeadingMarkdown()
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
endfunc
autocmd FileType markdown call HeadingMarkdown()

" When modifying crontab, use <leader>* as a shortcut for defining a cron that
" runs every minute.
autocmd FileType crontab noremap <buffer> <leader>* 5I* <esc>

" In .eml files, \q is used to quote text. Remove mapping since we are already
" using \ to go to the next tab and don't want any delay.
autocmd FileType mail unmap <buffer> \q

" Use <leader>h and <leader>H to simplify git rebase.
autocmd FileType gitrebase xnoremap <buffer> <leader>h :s/pick/squash<cr>
autocmd FileType gitcommit nnoremap <buffer> <leader>h G{kkdgg

" Set tabs to be 4 spaces and use tabs instead of spaces. This uses autocmd so
" we can override language-specific configuration. Python, for example, is
" configured to expand tabs to spaces. YAML is an exception where we want to
" expand tabs to spaces and use 2 spaces for indentation.
autocmd FileType * setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=0
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

" Use the same word boundary for all file types.
autocmd FileType * set iskeyword=@,48-57,_

" Enable spell checker for git commits, TeX, and text files. Since spell is
" 'local to window' rather than 'local to buffer', it is insufficient to use
" autocmd FileType. While it works when opening a file, opening the file again
" in a separate window will no longer have the spell checker enabled.
autocmd BufEnter * if index(["gitcommit", "markdown", "tex", "text"], &filetype) >= 0 | setlocal spell | endif

" Sometimes the spell checker does not work correctly in large TeX files. This
" seems to resolve most of the issue per https://goo.gl/dtuJSk. See
" https://goo.gl/YbxTHp for more information on spell checking in TeX files.
autocmd FileType tex syntax spell toplevel

" Treat .fs (F#), .kt (Kotlin), and .swift files as Scala files. They are
" obviously different but are similar enough for most of syntax highlighting and
" indentation to work. OCaml is another candidate for F# but it doesn't handle
" braces well.
autocmd BufRead,BufNewFile *.fs,*.kt,*.swift setlocal filetype=scala

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

" Use the enter key to trigger commands in normal mode. Since <cr> is typically
" used to execute a command in the command-line window (accessible via Ctrl-F),
" we will use :x instead.
nnoremap <cr> :
xnoremap <cr> :
autocmd CmdwinEnter * cabbrev <buffer> x <cr>

" Automatically resize splits in the active tab when the window is resized.
" Resize splits when switching to a tab to account for splits in background tabs
" when the window is resized.
autocmd VimResized,TabEnter * wincmd =

" Ctrl-U deletes to beginning of line and Ctrl-W deletes the last word.
" Recovering the deleted text is difficult. Ctrl-U can happen by accident such
" as when accidentally inserting a Unicode character with Ctrl-Shift-U. Create a
" separate change for Ctrl-U and Ctrl-W so they can be undone like other
" changes per https://bit.ly/2ZSlinw.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" When pasting over text with o, do not copy the deleted text. See
" https://bit.ly/2Mc0Ac9 for more information. Use O for the default visual
" pasting behavior.
xnoremap o pgvy
xnoremap O p

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

" Vim has a hard time when d above is preceded by a number. In Netrw, it only
" works when the preceding number is less than or equal to the number of lines
" between the current line and the end of the Netrw listing (inclusive). Use o
" for going up multiple directories. Typically the number of levels is small and
" the operation will use a right handed key followed by a left handed key.
for i in range(1,9)
	let path = repeat("../", i)
	let cmd = printf('autocmd FileType netrw nnoremap <buffer> o%d :call NetrwBrowse("%s")<cr>', i, path)
	exec cmd
endfor

" Define additional o keys for navigating to the root directory and the home
" directory.
autocmd FileType netrw nnoremap <buffer> os :call NetrwBrowse("/")<cr>
autocmd FileType netrw nnoremap <buffer> oh :call NetrwBrowse($HOME)<cr>

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

" Use <leader>q to save Vim session to file and use <leader>Q to load Vim
" session from file.
set sessionoptions=tabpages
func! SaveSession()
	try
		mksession ~/vim-session
		quitall
	endtry
endfunc
nnoremap <leader>q :call SaveSession()<cr>
func! LoadSession()
	source ~/vim-session
	call delete(expand("~/vim-session"))
endfunc
nnoremap <leader>Q :call LoadSession()<cr>

" Use <leader>u to convert from standard base64 encoding to URL base64 encoding.
nnoremap <leader>u :s/+/-/g<cr>:s/\//_/g<cr>

" Use <leader>w to close tab, similar to Ctrl-W in GUI programs.
nnoremap <leader>w :tabclose<cr>

" Use <leader>f to change case until end of the word.
nnoremap <leader>f ve~

" Use <leader>g to jump to the next Git conflict marker.
nnoremap <leader>g /=======<cr>

" Use <leader>a to sort visually selected lines. Sort by ASCII per
" https://goo.gl/HuZ6KL.
xnoremap <leader>a ! LC_ALL=C sort<cr>

" Use <leader>A to highlight non-ASCII characters.
nnoremap <leader>A /[^\x00-\x7F]<cr>

" Use <leader>t to search for triple TODO.
nnoremap <leader>t /TODO TODO<cr>

" Use <leader>z to correct word under cursor to first suggestion.
nnoremap <leader>z z=1<cr><cr>

" Use <leader>b to show the current buffer number.
nnoremap <leader>b :echo bufnr('%')<cr>

" Use <leader>i to make id uppercase.
nnoremap <leader>i :s/id\>/ID/g<cr>

" Use <leader>m to open netrw in new tab.
nnoremap <leader>m :Te<cr>

" Use <leader>l and <leader>L to set the spell language to English and Spanish
" respectively.
nnoremap <leader>l :setlocal spelllang=en<cr>
nnoremap <leader>L :setlocal spelllang=es<cr>

" Use <leader><tab> convert to tabs. In normal mode, it affects the current
" line. In visual mode, it affects every selected line.
noremap <leader><tab> :s/    /\t/g<cr>

" Use \ to go to next tab and <tab> to go to previous tab.
nnoremap \ :tabn<cr>
nnoremap <tab> :tabp<cr>
