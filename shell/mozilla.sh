# Define alias for opening files with Firefox.
function ff {
	# If exactly one file is given, it's necessary to use --new-window.
	# Otherwise the files must be specified directly.
	args=("-P" "default")
	if [[ $# -eq 1 ]]; then
		args+=("--new-window")
	fi

	# Convert file path to absolute path. Relative path does not work on macOS.
	for arg in "$@"; do
		if [[ "$arg" =~ ^http:// ]] || [[ "$arg" =~ ^https:// ]]; then
			args+=("$arg")
		else
			args+=("$(realpath "$arg")")
		fi
	done

	$firefox "${args[@]}"
}

# Define function to open index.html containing all images and videos in the
# specified directory.
function igff {
	ig "$@" && ff index.html && sleep 1 && rm index.html
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

# Sometimes Firefox or Thunderbird will use 100% CPU. Define function to help
# identify the profile that is responsible. The fuser command writes the path to
# standard error by default so pipe to standard output. This makes the result
# easier to grep.
function mozls {
	uname=$(uname)
	if [[ $uname == "Darwin" ]]; then
		fuser ~/Library/Thunderbird/Profiles/*/key4.db ~/Library/Application\ Support/Firefox/Profiles/*/key4.db 2>&1
	else
		fuser ~/.thunderbird/*/key4.db ~/.mozilla/firefox/*/key4.db 2>&1
	fi | sed 's/: */\t/' | column -t -s $'\t'
}
