set -e

while getopts "nq" opt; do
	case ${opt} in
		n)
			trim=1
			;;
		q)
			quiet=1
			;;
	esac
done

# Read standard input until EOF. Per https://bit.ly/47385eA, set IFS so leading
# whitespaces are not stripped since they are often useful for indentation.
# Suppress exit code as the "read" command will exit with non-zero status when
# it encounters EOF.
IFS= read -r -d "" input || true

# Print copied text.
if [[ ! $quiet ]]; then
	echo "${input%$'\n'}"
fi

# Trim trailing newline if called with -n.
if [[ $trim ]]; then
	input="${input%$'\n'}"
fi

function copy_os {
	if command -v xclip > /dev/null; then
		# Use nohup to keep xclip running until the clipboard content is
		# overwritten.
		printf %s "$input" | nohup xclip -sel clip > /dev/null 2>&1
	elif command -v pbcopy > /dev/null; then
		printf %s "$input" | pbcopy
	elif command -v clip.exe > /dev/null; then
		printf %s "$input" | clip.exe
	fi
}

# Exit if successfully copied to operating system clipboard, session is not over
# SSH, and session is not through tmux.
if copy_os; then
	if [[ ! $SSH_TTY ]] && [[ ! $TMUX ]]; then
		exit
	fi
fi

# Copy to clipboard with OSC 52. On Linux, disable breaking base64 output into
# multiple lines.
if [[ $(uname) == "Linux" ]]; then
	base64_flags="-w 0"
fi
printf '\e]52;c;%s\x07' $(printf %s "$input" | base64 $base64_flags)
