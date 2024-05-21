set -e

# Only allow one instance to run at a time.
if [[ -f ~/clipboard ]]; then
	echo Clipboard file already exists.
	read
	exit
fi

# Start with clipboard or empty document depending on argument.
if [[ "$1" == "paste" ]]; then
	bash $(dirname $0)/paste.sh > ~/clipboard
else
	> ~/clipboard
fi

# Copy to clipboard if Vim exits successfully. Copy operation can be aborted by
# exiting Vim with :cq.
if vi ~/clipboard; then
	cat ~/clipboard | bash $(dirname $0)/copy.sh
else
	echo "Vim exited with error. Press Enter to discard clipboard file. Press Ctrl-C to retain the file without copying."
	read
fi

rm ~/clipboard
