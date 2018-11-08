cd "$(dirname "$0")"
base=$(pwd)

# Source the repository .bashrc and .vimrc. This is preferred over a symlink
# since accounts may need custom configuration for bash and Vim. The repository
# .bashrc may be missing some platform-specific features but overwriting the
# user .bashrc ensures that $HISTSIZE and related variables work correctly.
if [[ $(uname) == "Darwin" ]]; then
	bashrc=~/.bash_profile
else
	bashrc=~/.bashrc
fi
echo 'source "'$base'/.bashrc"' > $bashrc
echo 'exec "source " . fnameescape("'$base/.vimrc'")' > ~/.vimrc

ln -s "$base/.gitconfig" ~/.gitconfig
ln -s "$base/.tmux.conf" ~/.tmux.conf

# Create directories for Vim temporary files.
mkdir -p ~/.vim/{backup,swap,undo}
