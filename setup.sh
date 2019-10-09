cd "$(dirname "$0")"
base=$(pwd)

# Unset branch upstream so running "git pull" directly has no effect.
git branch --unset-upstream

# If GPG is installed, import the signing public key. If the user has the
# corresponding secret key, sign commits in repository.
if hash gpg 2>/dev/null; then
	gpg --import public.pgp
	pubkey="3482E963C87B750D0D65E71BBBF920F2DB00633A"
	if gpg --list-secret-keys $pubkey &>/dev/null; then
		git config user.signingkey $pubkey
		git config commit.gpgsign true
	fi
fi

# Source the repository .bashrc and .vimrc. This is preferred over a symlink
# since accounts may need custom configuration for bash and Vim. The repository
# .bashrc may be missing some platform-specific features but overwriting the
# user .bashrc ensures that $HISTSIZE and related variables work correctly.
if [[ $(uname) == "Darwin" ]]; then
	bashrc=~/.bash_profile
else
	bashrc=~/.bashrc
fi
if [ ! -f $bashrc ]; then
	echo 'source "'$base'/.bashrc"' > $bashrc
fi
if [ ! -f ~/.vimrc ]; then
	echo 'exec "source " . fnameescape("'$base/.vimrc'")' > ~/.vimrc
fi

if [ ! -f ~/.gitconfig ]; then
	ln -s "$base/.gitconfig" ~
fi
if [ ! -f ~/.tmux.conf ]; then
	ln -s "$base/.tmux.conf" ~
fi

# Create directories for Vim temporary files.
mkdir -p ~/.vim/{backup,swap,undo}
