# Define alias for opening files with Firefox.
function ff {
	# If exactly one file is given, it's necessary to use --new-window.
	# Otherwise the files must be specified directly.
	args=("-P" "default")
	if [[ $# -eq 1 ]]; then
		args+=("--new-window")
	fi

	# For each file, convert path to absolute path. Relative path will not work
	# on macOS.
	for file in "$@"; do
		args+=("$(realpath "$file")")
	done

	$firefox "${args[@]}"
}

# Define alias for getting most recent screenshots. Use "ps" suffix for "print
# screen" instead of "ss" for "screenshot" to avoid same finger repetition.
alias lps='find "$(ssdir)" -maxdepth 1 -type f | grep -w Screen | sort | tail -n 1'

# Define alias for opening most recent screenshot.
function fps {
	file=$(lps)
	if [[ "$file" == "" ]]; then
		echo "screenshot not found"
		return 1
	else
		ff "$file"
	fi
}

# Define alias for deleting most recent screenshot. Open in Firefox for
# inspection and require confirmation to prevent accidental deletion.
alias rmps='fps && rm -i -v "$(lps)"'
