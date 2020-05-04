# On MacOS where the shasum command is used for the entire SHA family, define
# aliases so we can use the same commands as Linux. Similarly alias md5sum.
alias md5sum="md5"
alias sha1sum="shasum"
alias sha224sum="shasum -a 224"
alias sha256sum="shasum -a 256"
alias sha384sum="shasum -a 384"
alias sha512sum="shasum -a 512"

# Define alias to quickly enable and disable the system-wide SOCKS proxy when
# using WiFi. To enable and disable, use "nswfon" and "nswfoff" respectively.
alias nswf="networksetup -setsocksfirewallproxystate Wi-Fi"
alias nswfon="nswf on"
alias nswfoff="nswf off"
