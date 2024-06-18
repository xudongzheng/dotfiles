set -e

cd "$(dirname "$0")"

# If user has write access to dotfiles directory, make necessary changes to Git
# repository. Depending on the setup, the dotfiles repository may be shared
# between multiple users or multiple containers.
base=$(pwd)
if [[ -w "$base" ]]; then
	# Unset master branch upstream so running "git pull" directly has no effect.
	# Updates should be pulled using pull.sh. If branch upstream has already
	# been unset, suppress error to allow script to continue running.
	git branch --unset-upstream master || true

	# If GPG is installed, import the signing public key. If the user has the
	# corresponding secret key, sign commits in repository.
	if command -v gpg > /dev/null; then
		gpg --import public.pgp
		pubkey="3482E963C87B750D0D65E71BBBF920F2DB00633A"
		if gpg --list-secret-keys $pubkey &>/dev/null; then
			git config user.signingkey $pubkey
			git config commit.gpgsign true
		fi
	fi
fi

# Use .bashrc for Bash and .zshrc for Zsh.
if [[ $SHELL == "/bin/zsh" ]]; then
	bashrcSrc=~/.zshrc
else
	bashrcSrc=~/.bashrc
fi

# Configure Bash and Vim to source the repository .bashrc and .vimrc
# respectively. This is preferred over a symlink so the local user can be
# customized. For Bash, it is better to check if the repository file is sourced
# (rather than checking for its existence) since user directories typically come
# with a file by default.
bashrcDst="$base/.bashrc"
if ! grep -qs "$bashrcDst" $bashrcSrc; then
	echo "source \"$bashrcDst\"" > $bashrcSrc
fi
vimrcDst="$base/.vimrc"
if [[ ! -f ~/.vimrc ]]; then
	echo 'execute "source " .. fnameescape("'"$vimrcDst"'")' > ~/.vimrc
fi

# Source repository .ssh/config for SSH. If the repository is shared between
# multiple users, then .ssh/config must be owned by root for it to be included.
sshconfigDst="$base/.ssh/config"
if [[ ! -f ~/.ssh/config ]]; then
	mkdir -p ~/.ssh
	echo "Include \"$sshconfigDst\"" > ~/.ssh/config
	echo "Include config-*" >> ~/.ssh/config
fi

# Create symlinks for other configuration files.
files=(.gitconfig .inputrc)
if command -v gdb > /dev/null; then
	files+=(.gdbinit)
fi
if command -v screen > /dev/null; then
	files+=(.screenrc)
fi
if command -v tmux > /dev/null; then
	files+=(.tmux.conf)
fi
for file in "${files[@]}"; do
	if [[ ! -e "$HOME/$file" ]]; then
		ln -s "$base/$file" ~
	fi
done

# Create directories for Vim temporary files.
mkdir -p ~/.vim/{session,swap,undo}

# Suppress MOTD and "last login". On macOS, a new terminal tab opens with the
# same working directory as the current tab by default. Per the comments on
# https://bit.ly/45MZSJ2, .hushlogin is checked in the working directory.
# Configure terminal to open tabs in $HOME will always suppress the "last login"
# message. This behavior is preferred regardless as it's easier to open a new
# tab and run commands without first having to check the working directory.
touch ~/.hushlogin
