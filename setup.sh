set -e

cd "$(dirname "$0")"

# If user has write access to dotfiles directory, make necessary changes to Git
# repository. Depending on the setup, the dotfiles repository may be shared
# between multiple users or multiple containers.
base=$(pwd)
if [[ -w "$base" ]]; then
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

# Configure Bash (and Zsh) to source the repository .bashrc. In general,
# sourcing is preferred over creating a symlink so the local user can have
# additional configuration. This needs to check if the repository file is
# already sourced since new accounts typically come with a default file.
bashrcDst="$base/.bashrc"
if ! grep -qs "$bashrcDst" $bashrcSrc; then
	echo "source \"$bashrcDst\"" > $bashrcSrc
fi

# Configure Vim to source the repository .vimrc.
if [[ ! -f ~/.vimrc ]]; then
	echo "execute \"source \" .. fnameescape(\"$base/.vimrc\")" > ~/.vimrc
fi

# Source repository .ssh/config for SSH. If the repository is shared between
# multiple users, .ssh/config must be owned by root for the include to work.
if [[ ! -f ~/.ssh/config ]]; then
	mkdir -p ~/.ssh
	echo "Include \"$base/.ssh/config\"" > ~/.ssh/config
	echo "Include config-*" >> ~/.ssh/config
fi

# Configure Git to source the repository .gitconfig.
if [[ ! -f ~/.gitconfig ]]; then
	echo "[include]" > ~/.gitconfig
	echo -e "\tpath = $base/.gitconfig" >> ~/.gitconfig
fi

# Configure Readline to source the repository .inputrc.
if [[ ! -f ~/.inputrc ]]; then
	echo "\$include $base/.inputrc" > ~/.inputrc
fi

# Configure tmux to source the repository .tmux.conf.
if [[ ! -f ~/.tmux.conf ]]; then
	echo "source-file $base/.tmux.conf" > ~/.tmux.conf
fi

# Configure GDB to source the repository .gdbinit.
if [[ ! -f ~/.gdbinit ]]; then
	echo "source $base/.gdbinit" > ~/.gdbinit
fi

# Create symlinks for applications that do not support external sourcing.
files=()
if command -v screen > /dev/null; then
	files+=(.screenrc)
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

# Build binary for IME integration.
uname=$(uname)
if [[ $uname == "Darwin" ]]; then
	if [[ -w vim ]] && [[ ! -e vim/mac_ime ]]; then
		swiftc -o vim/mac_ime vim/mac_ime.swift
	fi
fi
