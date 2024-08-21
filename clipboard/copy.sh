set -e

while getopts "q" opt; do
	case ${opt} in
		q)
			quiet=1
			;;
	esac
done

# Read standard input until EOF. Suppress exit code as the "read" command will
# exit with non-zero status when it encounters EOF.
read -r -d "" input || true

# Trim trailing newline before copying to clipboard.
function echo_input { echo -n "$input"; }

function copy_os {
	if command -v xclip > /dev/null; then
		# Use nohup to keep xclip running until the clipboard content is replaced.
		echo_input | nohup xclip -sel clip > /dev/null 2>&1
	elif command -v pbcopy > /dev/null; then
		echo_input | pbcopy
	elif command -v clip.exe > /dev/null; then
		echo_input | clip.exe
	else
		return 1
	fi
}

function copy_tmux {
	if command -v tmux > /dev/null; then
		# Prior to tmux 3.3a, text must be manually wrapped in escape sequence
		# for bracketed paste.
		version=$(tmux -V)
		if [[ "$version" < "tmux 3.3a" ]]; then
			(echo -en "\e[200~" && echo_input && echo -en "\e[201~") | tmux load-buffer -
		else
			echo_input | tmux load-buffer -
		fi
	else
		return 1
	fi
}

# Attempt to copy to operating system clipboard. If that fails, copy to tmux
# clipboard.
if ! copy_os; then
	if ! copy_tmux; then
		if [[ "$quiet" == "" ]]; then
			echo "Unable to copy to clipboard"
			exit 1
		fi
	fi
fi

# Print copied text if successful.
echo "$input"
