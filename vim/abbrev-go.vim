" Define abbreviation for Go import paths.
func! AbbrevGoImport()
	iab <buffer> tbion "bufio"
	iab <buffer> tbn "bytes"
	iab <buffer> tcn "context"
	iab <buffer> tcsn "crypto/subtle"
	iab <buffer> tctn "crypto/tls"
	iab <buffer> tcxn "crypto/x509"
	iab <buffer> tdsn "database/sql"
	iab <buffer> tebin "encoding/binary"
	iab <buffer> tebn "encoding/base64"
	iab <buffer> tecn "encoding/csv"
	iab <buffer> tehn "encoding/hex"
	iab <buffer> tejn "encoding/json"
	iab <buffer> tepn "encoding/pem"
	iab <buffer> tern "errors"
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
	iab <buffer> b64std base64.StdEncoding
	iab <buffer> b64url base64.URLEncoding
	iab <buffer> bnbn bytes.NewBuffer(nil)
	iab <buffer> bytn Bytes()
	iab <buffer> cctx context.Context
	iab <buffer> cltn Close()
	iab <buffer> ctxg ctx := context.Get(rw)
	iab <buffer> cvbyte []byte
	iab <buffer> dbb DB.Begin()<cr>defer tx.Rollback()<cr>
	iab <buffer> dbe DB.Exec
	iab <buffer> dbq DB.Query
	iab <buffer> dbqr DB.QueryRow
	iab <buffer> dcc defer conn.Close()
	iab <buffer> dfc defer f.Close()
	iab <buffer> dftn defer func() {<cr><cr>}()<up><bs>
	iab <buffer> drbc defer resp.Body.Close()
	iab <buffer> eioe err == io.EOF
	iab <buffer> enl err != nil {<cr>log.Fatal(err)<cr>}
	iab <buffer> enp err != nil {<cr>panic(err)<cr>}
	iab <buffer> enr err != nil {<cr>return err<cr>}
	iab <buffer> ent err != nil {<cr>t.Fatal(err)<cr>}
	iab <buffer> enw err != nil {<cr>log.Warn(err)<cr>}
	iab <buffer> erows err = rows.Scan(
	iab <buffer> errtn err.Error()
	iab <buffer> ertn Error()
	iab <buffer> ertw errors.New("TODO TODO TODO wip")
	iab <buffer> foid fusion.ObjectID
	iab <buffer> gftn go func() {<cr><cr>}()<up><bs>
	iab <buffer> ifce interface{}
	iab <buffer> imc import "C"
	iab <buffer> imtn import (<cr><cr>)<cr><up><up><bs>
	iab <buffer> initn func init() {<cr><cr>}<up><bs>
	iab <buffer> ioe io.EOF
	iab <buffer> ior io.Reader
	iab <buffer> iow io.Writer
	iab <buffer> maintn func main() {<cr><cr>}<up><bs>
	iab <buffer> nametn Name()
	iab <buffer> netcn net.Conn
	iab <buffer> netip net.IP
	iab <buffer> nfoid fusion.NewObjectID()
	iab <buffer> osf *os.File
	iab <buffer> pkgm package main
	iab <buffer> rnil return nil
	iab <buffer> rntn rows.Next()
	iab <buffer> senr err == sql.ErrNoRows
	iab <buffer> strtn String()
	iab <buffer> tcotn tx.Commit()
	iab <buffer> tdur time.Duration
	iab <buffer> tnow time.Now()
	iab <buffer> ttime time.Time
	iab <buffer> ttm t *testing.M
	iab <buffer> ttt t *testing.T
	iab <buffer> txerr tx, err :=
	iab <buffer> utctn UTC()
	iab <buffer> x5c *x509.Certificate

	" Define abbreviations for looping through slices.
	iab <buffer> fkr for key := range
	iab <buffer> fkr1 for k1 := range
	iab <buffer> fkr2 for k2 := range
	iab <buffer> fkr3 for k3 := range
	iab <buffer> fkvr for key, value := range
	iab <buffer> fkvr1 for k1, v1 := range
	iab <buffer> fkvr2 for k2, v2 := range
	iab <buffer> fkvr3 for k3, v3 := range
	iab <buffer> fvr for _, value := range
	iab <buffer> fvr1 for _, v1 := range
	iab <buffer> fvr2 for _, v2 := range
	iab <buffer> fvr3 for _, v3 := range
endfunc
autocmd FileType go call AbbrevGoSnippets()

" Define visual mapping for common Go snippets.
func! MapGoSnippets()
	xnoremap <leader>b c[]byte()<esc>P
	xnoremap <leader>l clen()<esc>P
	xnoremap <leader>s cstring()<esc>P
	xnoremap <leader>f cfloat64()<esc>P
endfunc
autocmd FileType go call MapGoSnippets()
