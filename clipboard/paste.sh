set -e

if command -v xclip > /dev/null; then
	# Suppress xclip error, which may occur if the clipboard is empty or if an
	# image is copied.
	xclip -out -sel clip 2>/dev/null || true
elif command -v pbpaste > /dev/null; then
	pbpaste
fi
