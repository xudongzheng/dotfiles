# Increase Bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

# Set xterm title.
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;\u@\h:\w\a\]$PS1"
		;;
esac

alias vhi="vi ~/.bash_history"
