# Set terminal prompt and xterm title. The zero-length portion of $PS1 is
# wrapped with %{ and %} so the prompt length is calculated correctly.
term_title="%n@%m:%~"
PS1=$'%{\e]0;'"$term_title"$'\a%}'"$term_title\$ "

# Use Emacs bindings. This is already the default when Zsh is launched from
# macOS terminal or remote SSH. For some reason, Vim bindings is the default
# when Zsh is launched from GNU Screen.
bindkey -e

# Increase Zsh history size. $SAVEHIST increases the number of entries written
# to the history file. $HISTSIZE increases the number of entries loaded from the
# history file and available for searching with Ctrl-R.
SAVEHIST=100000
HISTSIZE=100000

# Include additional characters in $WORDCHARS. When deleting with Ctrl-W, these
# should be deleted as part of the surrounding word.
WORDCHARS=":|@'\"\`$WORDCHARS"

# Store history with timestamp.
setopt EXTENDED_HISTORY

# Ignore consecutive duplicate commands.
setopt HIST_IGNORE_DUPS

# Exclude commands that start with a space from history. The command will
# temporarily remain in the shell's internal history until the next command so
# it can be reused.
setopt HIST_IGNORE_SPACE

# Allow comments in interactive shell. This is useful for adding something to
# the history without executing it.
setopt INTERACTIVE_COMMENTS

# If a glob pattern has no match, leave pattern as is without generating an
# error to be consistent with Bash.
setopt NO_NOMATCH

# Define mapping for editing the current command and bind Ctrl-X Ctrl-E. The
# first line opens the buffer in a text editor. The second line executes it,
# which is the Bash behavior.
autoload -U edit-command-line
function edit-command-line-execute {
	edit-command-line
	zle accept-line
}
zle -N edit-command-line-execute
bindkey '^x' edit-command-line-execute

# There are other builtin mappings with Ctrl-X as prefix so set timeout to 10ms
# to ignore those. The default value is 40, which corresponds to 400ms per the
# zshzle man page.
KEYTIMEOUT=1

# Use Alt and Ctrl with left and right arrows to navigate by words. This comes
# from https://bit.ly/3NJvfhJ.
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# For the "history" command, use same timestamp format as Bash.
alias history="history -t '[%Y-%m-%d %H:%M:%S %Z]' -i 0"

alias vhi="vi ~/.zsh_history"
