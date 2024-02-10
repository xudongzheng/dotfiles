# Set default editor. On most platforms, Vi and Vim both refer to the same
# editor. When using Ctrl-X Ctrl-E, Zsh's edit-command-line tries to advance the
# cursor to the same position as it was in terminal, which is not the behavior
# that we want since Bash doesn't do that. Per https://bit.ly/2PZ3iVn, Zsh does
# this with Vim but not Vi.
export EDITOR=vi

# Python pip can install packages without root into ~/.local/bin. If such
# directory exists, add it to $PATH.
if [[ -d ~/.local/bin ]]; then
	export PATH=~/.local/bin:$PATH
fi

# Get path to current file per https://bit.ly/33OR2Lh. The logic varies between
# Bash and Zsh and this should work with both.
bashSource="${BASH_SOURCE[0]:-${(%):-%x}}"

# Load shell specific code.
if [[ $SHELL == "/bin/bash" ]]; then
	source "$(dirname $bashSource)/shell/bash.sh"
elif [[ $SHELL == "/bin/zsh" ]]; then
	source "$(dirname $bashSource)/shell/zsh.sh"
fi

# Define aliases for checksums on macOS to match the commands on Linux.
uname=$(uname)
if [[ $uname == "Darwin" ]]; then
	alias md5sum="md5"
	alias sha1sum="shasum"
	alias sha224sum="shasum -a 224"
	alias sha256sum="shasum -a 256"
	alias sha384sum="shasum -a 384"
	alias sha512sum="shasum -a 512"
fi

# Define function to prevent Vim from piped to another program. This can happen
# when I'm working with large amounts of text and using Vim as a pager. This comes from
# https://bit.ly/3FG7m65.
function vi {
	if [[ -t 1 ]]; then
		command vi "$@"
	else
		echo "Vim must run with TTY as standard output" >&2
	fi
}

# Define function for copying standard input to clipboard.
function xc {
	if command -v pbcopy > /dev/null; then
		pbcopy
	elif command -v xclip > /dev/null; then
		xclip -sel clip
	fi
}

# The ls command is different on Linux and macOS. Set color scheme for macOS
# per https://goo.gl/1ps44T.
if [[ $uname == "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
	alias l="ls"
else
	alias l="LC_ALL=C.UTF-8 ls --group-directories-first --color=auto"
fi

# Define aliases for top.
if [[ $uname == "Darwin" ]]; then
	alias tom="top -o mem"
else
	alias top="top -E m -e m -o %CPU"
	alias tom="top -E m -e m -o %MEM"
fi

# Define realpath function for converting relative path to absolute path. The
# command exists natively in Linux but not macOS.
if [[ $uname == "Darwin" ]]; then
	function realpath {
		echo $(cd $(dirname "$1") && pwd)/$(basename "$1")
	}
fi

# Define alias for ps.
if [[ $uname == "Darwin" ]]; then
	alias p="ps aux"
else
	alias p="ps auxf"
fi
alias pg="p | ep"

alias autk="vi ~/.ssh/authorized_keys"
alias c="cd"
alias cm="c - > /dev/null"
alias crt="crontab -e"
alias dfh="df -h"
alias dr="date --rfc-3339=seconds"
alias ep="grep --color"
alias epi="ep -i"
alias epr="ep -Rn"
alias epri="epr -i"
alias eprtt="epr 'TODO TODO'"
alias fep="find . | ep"
alias fm="free -m"
alias fms="fm -s 5"
alias hig="history | ep"
alias ll="l -hla"
alias n="netstat -nlp"
alias ng="n | ep"
alias rp="realpath"
alias sort="LC_ALL=C sort"
alias tm="touch -m"
alias usm="useradd -s /bin/bash -m"
alias vid="vi -"
alias vie="vi -c Explore"
alias vrc="vi .vimrc"
alias wl="wc -l"

# Define alias for cutting words. Use "tr" to squeeze multiple consecutive
# spaces into one. "cutw n" prints the n-th word on every line. "cutw n-" prints
# every word starting from the n-th word on every line.
alias cutw="tr -s ' ' | cut -d ' ' -f"

# Define alias for xargs. This replaces \n with \x00 so filenames containing
# spaces are handled correctly.
alias xargs="tr '\n' '\0' | xargs -0"

# Use dfmt to format Go code using gofmt. Use wfmt to format it in the working
# directory. Use gfmt to do it across the entire Git repository.
alias dfmt="gofmt -w=true -s"
alias wfmt="dfmt ."
alias gfmt='dfmt $(git rev-parse --show-toplevel)'

# Define alias for insecure SSH. This is useful before we reserve a static IP
# for a new device. Generally we use SSH keys for authentication so there's
# limited security risk of not checking the host key.
alias sins="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias sinsr="sins -l root"

# Define aliases for tar. When extracting as root, tar will extract with the
# setuid/setgid attribute by default. This can be a problem when untrusted
# archives are extracted to a location accessible to other users so prevent this
# with --no-same-permissions. As root tar also defaults to maintaining file
# ownership when extracting. This is disabled with --no-same-owner.
alias tarcf="tar cf"
alias tarzcf="tar zcf"
alias tarxf="tar --no-same-permissions --no-same-owner -xf"

# Create an alias for cp and mv as to prompt before overwriting existing files.
alias cp="cp -i"
alias mv="mv -i"

# Create function to undo mv. This can be easily accessed by editing the initial
# mv command and adding the prefix.
function unmv {
	mv "$2" "$1"
}

# Create aliases for calculating size of directories and files. Use --summarize
# (-s) subdirectories are not calculated separately. Use the -b flag to consider
# the size of the file contents rather than the size used on disk.
alias dubh="du -sbh"
alias duh="du -sh"

# Create alias for parsing x509 certificate.
alias osx509="openssl x509 -text -noout -in"

function aliasDir {
	# When multiple directories are given, create alias for first directory that
	# exists.
	for dir in "${@:2}"; do
		if [[ -d "$dir" ]]; then
			alias $1="c '$dir'"
			return
		fi
	done
}

# Create aliases for changing to common directories for directories that exists.
aliasDir cde ~/Desktop
aliasDir cdl ~/Downloads
aliasDir cdoc ~/Documents
aliasDir csh ~/.ssh
aliasDir csr ~/src
aliasDir css ~/Documents/screenshot

# Define alias for changing to the dotfiles directory.
dotDir=$(dirname "$bashSource")
aliasDir cdot "$dotDir"

function viargs {
	for file in "$@"; do
		if [[ -e "$file" ]]; then
			vi "$file"
			return
		fi
	done
	echo "unable to find matching file"
}

# Define function to edit various files in the working directory.
alias src="viargs .bashrc .zshrc"
alias vrm="viargs readme.* README.*"

# Use dqap (like in Vim) to undo line wrapping in a file. This is very similar
# to the "fmt" command. Per https://goo.gl/PfzvyS, the Linux "fmt" has a limit
# of 2500 characters per line whereas the Perl command does not. The "fmt"
# command also has some strange behavior with regards to lines that end with a
# period, especially when they are indented. The Perl command has no such issue.
function dqap {
	perl -00ple 's/\s*\n\s*/ /g' "$@"
}

# Use cu to travel up multiple parent directories. If no arguments, go up one
# directory.
function cu {
	count="$1"
	if [[ $count == "" ]]; then
		count=1
	fi
	str=$(seq -f "..%g" -s / $count | sed "s/[0-9]//g")
	cd $str
}

# Define xe as an alternative for fc. The name was chosen since Ctrl-X Ctrl-E is
# used for editing the current command. This is preferred over fc as that
# requires two consecutive presses with the same finger.
function xe {
	builtin fc
}

# Use cdn to go to the directory containing a given file. This is helpful when
# using recursive grep as one can double click the path (assuming it does not
# contain spaces) and use this to change to the directory containing the file.
function cdn {
	cd $(dirname "$1")
}

# Similar to cdn above, use ndc to do edit the file.
function ndc {
	files=()
	for file in "$@"; do
		file=$(cut -d : -f 1 <<< "$file")
		files+=("$file")
	done
	vi "${files[@]}"
}

# Use dotc to print and copy command for setting up dotfiles on a new server or
# user.
function dotc {
	cmd=""
	if [[ "$1" == "apt" ]]; then
		cmd="apt update && apt install -y git vim tmux && "
	fi
	commit=$(git -C "$dotDir" rev-parse master)
	cmd+="git clone https://github.com/xudongzheng/dotfiles.git dot && cd dot && git checkout $commit && git branch -f master HEAD && bash setup.sh && exit"
	echo $cmd
	echo $cmd | xc
}

# Use pub to print Ed25519 public key. It will generate a new key if one does
# not exist.
function pub {
	if [[ ! -f ~/.ssh/id_ed25519 ]]; then
		ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" > /dev/null
	fi
	cat ~/.ssh/id_ed25519.pub
}

# Use pubxc to print and copy the local SSH public key.
alias pubxc="pub && pub | xc"

# Use pubc to print and copy command for adding the local SSH public key to
# .ssh/authorized_keys.
function pubc {
	cmd='mkdir -p ~/.ssh && echo "'$(pub)'" >> ~/.ssh/authorized_keys'
	echo $cmd
	echo $cmd | xc
}

# Use mkc to create and change to a directory. Create parent directories if
# necessary.
function mkc {
	mkdir -p "$1" && cd "$1"
}

# Define function to sort directory from smallest to largest.
function lsort {
	if [[ "$1" == "" ]]; then
		dir="."
	else
		dir="$1"
	fi
	find "$dir" -mindepth 1 -maxdepth 1 | xargs du -sh | sort -h
}

# Use s to run script to avoid accidentally using the incorrect interpreter or
# compiler.
function s {
	ext="${1##*.}"
	case $ext in
		go)
			go run "$@"
			;;
		php)
			php "$@"
			;;
		pl)
			perl "$@"
			;;
		py)
			python3 "$@"
			;;
		sh)
			bash "$@"
			;;
		swift)
			swift "$@"
			;;
		*)
			echo unrecognized script extension
			;;
	esac
}

# If Python available, use jfmt to format JSON and phttp to start a HTTP server
# for static files.
if command -v python3 > /dev/null; then
	alias jfmt="python3 -m json.tool"
	alias phttp="python3 -m http.server"
fi

# Define alias for tmux or GNU Screen.
if command -v tmux > /dev/null; then
	alias t="tmux new-session -t 0 || tmux"
elif command -v screen > /dev/null; then
	alias t="screen -x || screen"
fi

# If wget is not available but cURL is available (such as on macOS), allow cURL
# to be invoked using the wget command.
if ! hash wget 2>/dev/null; then
	if command -v curl > /dev/null; then
		function wget {
			# Do not overwrite existing file.
			name=$(basename "$1")
			if [[ -f "$name" ]]; then
				name=$(mktemp "${name}XXXXXX")
			fi

			# Include -L to follow redirects.
			curl -o "$name" -L "$1"
		}
	fi
fi

# If apt is available, define related aliases. Some are only necessary of the
# user is root.
if command -v apt > /dev/null; then
	# Use aps instead of acs for alias since c and s use the same finger.
	alias aps="apt-cache search"

	if [[ $USER == "root" ]]; then
		alias apar="apt autoremove"
		alias apd="apt update"
		alias apg="apt upgrade --with-new-pkgs"
		alias api="apt install"
		alias apr="apt remove"
		alias apu="apd && apg"
	fi

	# Use ali to list all installed packages. This writes standard error of "apt
	# list" to /dev/null since it give a warning about not having a stable CLI
	# interface when the output goes to a pipe instead of a terminal.
	alias ali="apt list --installed 2>/dev/null"
	alias aliep="ali | ep"
fi

# Define aliases for Go.
if command -v go > /dev/null; then
	alias gob="go build"
	alias gog="go generate"
	alias got="go test -c"
	alias gotn="got -o /dev/null"
fi

if command -v git > /dev/null; then
	source "$(dirname $bashSource)/shell/git.sh"
fi

if [[ $uname == "Darwin" ]]; then
	firefox=/Applications/Firefox.app/Contents/MacOS/firefox
else
	firefox=firefox
fi
if command -v $firefox > /dev/null; then
	source "$(dirname $bashSource)/shell/firefox.sh"
fi
