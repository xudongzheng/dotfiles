# Set terminal prompt and xterm title. The zero-length portion of $PS1 is
# wrapped with \[ and \] so the prompt length is calculated correctly.
term_title="\u@\h:\w"
PS1="\[\e]0;$term_title\a\]$term_title\$ "

# Increase Bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

alias vhi="vi ~/.bash_history"
