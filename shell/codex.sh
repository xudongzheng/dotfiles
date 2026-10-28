codex_args=()

# TODO TODO TODO keep in dotfiles? or in agents?

# When running in Docker, define alias to run Codex without sandbox.
if [[ -f /.dockerenv ]]; then
	codex_args+=(--strict-config --sandbox danger-full-access)
fi

codex_config=(
	# Set default model.
	"model='gpt-6.1-sol'"

	# Do not allow Escape to interrupt conversation in progress since it is easy
	# to press accidentally.
	"tui.keymap.chat.interrupt_turn=[]"

	# Use Ctrl-X to edit command in Vim.
	"tui.keymap.global.open_external_editor='ctrl-x'"

	# Include thread ID in status line. This is so I can easily copy it and
	# export the chat to a Markdown file.
	"tui.status_line=['model-with-reasoning','current-dir','thread-id']"
)

# Codex configuration options are passed as arguments since it's not possible to
# include a central .toml file. As of Codex CLI 0.162.1, using a profile doesn't
# work since Codex will write to the shared profile file.
for config in "${codex_config[@]}"; do
	codex_args+=(--config "$config")
done

function cdx() {
	codex "${codex_args[@]}" "$@"
}

# When called without a UUID, this lists all sessions for the working directory.
alias cdxr="cdx resume"

# This lists all sessions across all working directories.
alias cdxra="cdx resume --all"
