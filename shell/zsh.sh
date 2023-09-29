# Use the same prompt format as Bash on Linux.
PROMPT="%n@%m:%~$ "

# Use Emacs bindings. This is already the default when Zsh is launched from
# macOS terminal or remote SSH. For some reason, Vim bindings is the default
# when Zsh is launched from GNU Screen.
bindkey -e

# Increase Zsh history size. $SAVEHIST increases the number of entries written
# to the history file. $HISTSIZE increases the number of entries loaded from the
# history file and available for searching with Ctrl-R.
SAVEHIST=100000
HISTSIZE=100000

# Include colon and vertical bar in $WORDCHARS. This ensures consistent behavior
# with Bash when Ctrl-W is used with URLs, IPv6 addresses, or piped commands.
WORDCHARS=":|$WORDCHARS"

# Store history with timestamp.
setopt EXTENDED_HISTORY

# Ignore consecutive duplicate commands.
setopt HIST_IGNORE_DUPS

# Ignore commands starting with a space.
setopt HIST_IGNORE_SPACE

# Define custom function for editing the current command and bind Ctrl-X Ctrl-E.
autoload -U edit-command-line
function editCommandLine {
	if [[ $PREBUFFER == "" ]]; then
		# If the command is a single line, edit with text editor and execute
		# immediately. This is the Bash behavior and is distinct from the Zsh
		# edit-command-line behavior, which requires manually hitting Enter.
		() {
			exec </dev/tty
			"$EDITOR" $1
			BUFFER="$(<$1)"
		} =(<<<"$BUFFER")
		zle accept-line
	else
		# If input spans multiple lines, use default edit-command-line function.
		# This is acceptable as I rarely deal with a command spanning multiple
		# lines. It doesn't seem that this works with "zle accept-line". It's
		# possible to use edit-command-line from https://bit.ly/3fi7Oc8 though
		# we do not as dealing with multiple lines is weird as is.
		edit-command-line
	fi
}
zle -N editCommandLine
bindkey '^x^e' editCommandLine

alias history="history -i 0"
alias vhi="vi ~/.zsh_history"
