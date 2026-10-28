codex_args=()

# TODO TODO TODO keep in dotfiles? or in agents?

# Copy URLs to the clipboard when Codex invokes BROWSER. TODO TODO TODO A bug in
# Codex's webbrowser dependency leaves exited browser processes defunct instead
# of reaping them. The library correctly waits for recognized text browsers, so
# this wrapper is temporarily named "lynx" instead of "browser.sh". See
# https://github.com/amodm/webbrowser-rs/issues/126.
export BROWSER="$dot_dir/clipboard/lynx"

# When running in Docker, define alias to run Codex without sandbox.
if [[ -f /.dockerenv ]]; then
	codex_args+=(--strict-config --sandbox danger-full-access)
fi

codex_config=(
	# Set default model.
	"model='gpt-6.2-sol'"

	# Hide prompt to change the model when approaching rate limits.
	"notice.hide_rate_limit_model_nudge=true"

	# Do not allow Escape to interrupt conversation in progress since it is easy
	# to press accidentally.
	"tui.keymap.chat.interrupt_turn=[]"

	# In the agent command center, h hides a conversation. Disable as that is
	# very easy to do accidentally.
	"tui.keymap.agents.hide=[]"

	# Use Ctrl-X to edit command in Vim.
	"tui.keymap.global.open_external_editor='ctrl-x'"

	# When resuming session, always use session working directory.
	"tui.resume_cwd='session'"

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
