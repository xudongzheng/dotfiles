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
		# Use nohup to keep xclip running until the clipboard content is replaced.
		echo_input | nohup xclip -sel clip > /dev/null 2>&1
	elif command -v pbcopy > /dev/null; then
		echo_input | pbcopy
	elif command -v clip.exe > /dev/null; then
		echo_input | clip.exe
	fi
}

# Attempt to copy to operating system clipboard. Suppress error, which may
# happen if xterm is present but terminal is active over SSH.
copy_os || true

# Print copied text.
if [[ ! $quiet ]]; then
	echo "$input"
fi

# Copy to clipboard with OSC 52.
printf '\e]52;c;%s\x07' $(echo_input | base64 -w 0)
