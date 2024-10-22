set -e

while getopts "q" opt; do
	case ${opt} in
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

# Trim trailing newline.
input="${input%$'\n'}"

# Define function to print input without additional newline.
function echo_input { echo -n "$input"; }

function copy_os {
	if command -v xclip > /dev/null; then
		# Use nohup to keep xclip running until the clipboard content is
		# overwritten.
		echo_input | nohup xclip -sel clip > /dev/null 2>&1
	elif command -v pbcopy > /dev/null; then
		echo_input | pbcopy
	elif command -v clip.exe > /dev/null; then
		echo_input | clip.exe
	fi
}

# Print copied text.
if [[ ! $quiet ]]; then
	echo "$input"
fi

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
	base64Flags="-w 0"
fi
printf '\e]52;c;%s\x07' $(echo_input | base64 $base64Flags)
