# Set environment variables for using Vim as man pager.
if command -v man > /dev/null; then
	export MANWIDTH=80
	if [[ $uname != "Darwin" ]]; then
		export MANOPT="--no-hyphenation --no-justification"
	fi
	export MANPAGER="sh -c 'col -bx | vi - -c set\ filetype=man'"
fi

# Define function to prevent piping to Vim or piping Vim to somewhere. This can
# happen accidentally when working with large amounts of text and using Vim as a
# pager. This comes from https://bit.ly/3FG7m65.
function vi {
	if [[ ! -t 1 ]]; then
		echo "Vim must run with TTY as standard output" >&2
	elif [[ ! -t 0 ]]; then
		echo "Vim must run with TTY as standard input"
	else
		command vi "$@"
	fi
}

# Define function using Vim as a scratch area. It's similar to using Vim as a
# pager except the body can be easily modified.
function vis {
	if [[ ! -t 1 ]]; then
		echo "Vim must run with TTY as standard output" >&2
	elif [[ -t 0 ]]; then
		echo "Vim expecting pipe as standard input"
	else
		command vi -
	fi
}

# Define additional Vim aliases. This uses "vi -d" instead of "vimdiff" so input
# and output TTY are checked via the "vi" function.
alias vid="vi -d"
alias vie="vi -c Explore"
alias vrc="vi .vimrc"
