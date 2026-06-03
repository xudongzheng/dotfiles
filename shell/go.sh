# Disable automatic Go toolchain download.
export GOTOOLCHAIN=local

# Define aliases for Go.
alias gob="go build"
alias gog="go generate"
alias got="go test -c"
alias gotn="got -o /dev/null"
