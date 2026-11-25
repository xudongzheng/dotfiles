#!/bin/bash

set -e

# Only allow one instance to run at a time.
clipboard_file=~/clipboard.md
if [[ -f $clipboard_file ]]; then
	echo Clipboard file already exists.
	read
	exit
fi

# Start with clipboard or empty document depending on argument.
dir=$(dirname $0)
if [[ "$1" == "paste" ]]; then
	bash $dir/paste.sh > $clipboard_file
else
	> $clipboard_file
fi

# Copy to clipboard if Vim exits successfully. Copy operation can be aborted by
# exiting Vim with :cq.
if vi $clipboard_file; then
	cat $clipboard_file | bash $dir/copy.sh
else
	echo "Vim exited with error. Press Enter to discard clipboard file. Press Ctrl-C to retain the file without copying."
	read
fi

rm $clipboard_file
