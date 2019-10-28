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

# On CoreOS, use .bash_profile for Bash configuration. Otherwise use .bashrc for
# Bash and .zshrc for Zsh.
if [ -d /etc/coreos ]; then
	bashrcSrc=~/.bash_profile
elif [ "$SHELL" == "/bin/zsh" ]; then
	bashrcSrc=~/.zshrc
else
	bashrcSrc=~/.bashrc
fi

# Update Bash and Vim to source the repository .bashrc and .vimrc. This is
# preferred over a symlink since accounts may need custom configuration for Bash
# and Vim. The repository .bashrc may be missing some platform-specific features
# but overwriting the user .bashrc ensures that $HISTSIZE and similar variables
# work correctly.
bashrcDst="$base/.bashrc"
if ! grep -qs "$bashrcDst" $bashrcSrc; then
	echo "source \"$bashrcDst\"" > $bashrcSrc
fi
vimrcDst="$base/.vimrc"
if ! grep -qs "$vimrcDst" ~/.vimrc; then
	echo 'exec "source " . fnameescape("'"$vimrcDst"'")' > ~/.vimrc
fi

# Create symlinks for other configuration files.
files=(.gitconfig .inputrc)
if hash tmux 2>/dev/null; then
	files+=(.tmux.conf)
fi
for file in "${files[@]}"; do
	if [ ! -f "~/$file" ]; then
		ln -fs "$base/$file" ~
	fi
done

# Create directories for Vim temporary files.
mkdir -p ~/.vim/{backup,swap,undo}
