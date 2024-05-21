set -e

# Read standard input until EOF. Suppress exit code as the "read" command will
# exit with non-zero status when it encounters EOF.
read -r -d "" input || true

# Trim trailing newline if it exists and copy to clipboard.
if command -v xclip > /dev/null; then
	# Use nohup to keep xclip running until the clipboard content is replaced.
	echo -n "$input" | nohup xclip -sel clip > /dev/null 2>&1
elif command -v pbcopy > /dev/null; then
	echo -n "$input" | pbcopy
elif command -v clip.exe > /dev/null; then
	echo -n "$input" | clip.exe
else
	echo "Unable to copy to clipboard"
	exit 1
fi

# Print copied text if successful.
echo "$input"
