# Increase Bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

alias vhi="vi ~/.bash_history"
