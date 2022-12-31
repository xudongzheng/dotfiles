export TERM=xterm-256color

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

# The ls command is different on Linux and macOS. Set color scheme for macOS
# per https://goo.gl/1ps44T.
if [[ $uname == "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
	alias l="ls"
else
	alias l="ls --group-directories-first --color=auto"
fi

# Define aliases for top.
if [[ $uname == "Darwin" ]]; then
	alias tom="top -o mem"
else
	alias top="top -E m -e m -o %CPU"
	alias tom="top -E m -e m -o %MEM"
fi

# Define realpath function for resolving absolute path.
if [[ $uname == "Darwin" ]]; then
	function realpath {
		echo $(cd $(dirname "$1") && pwd)/$(basename "$1")
	}
fi

alias autk="vi ~/.ssh/authorized_keys"
alias c="cd"
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
alias p="ps aux"
alias pg="p | ep"
alias tm="touch -m"
alias usm="useradd -s /bin/bash -m"
alias vi="vim"
alias vid="vi -"
alias vie="vi -c Explore"
alias vrc="vi .vimrc"
alias wl="wc -l"

# Define alias for xargs to correctly handle lines containing spaces.
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
# setuid/setgid attributes by default. This can be a problem when untrusted
# archives are extracted to a location accessible to other users. Include
# --no-same-permissions to prevent this issue.
alias tarcf="tar cf"
alias tarzcf="tar zcf"
alias tarxf="tar --no-same-permissions -xf"

# Create an alias for cp and mv as to prompt before overwriting existing files.
alias cp="cp -i"
alias mv="mv -i"

# Create aliases for calculating size of directories and files. Use --summarize
# (-s) subdirectories are not calculated separately. Use the -b flag to consider
# the size of the file contents rather than the size used on disk.
alias dubh="du -sbh"
alias duh="du -sh"

# Create alias for parsing x509 certificate.
alias osx509="openssl x509 -text -noout -in"

function aliasDir {
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

# Define function to edit shell configuration file in the working directory.
function src {
	shellrc=(.bashrc .zshrc)
	for value in "${shellrc[@]}"; do
		if [[ -f $value ]]; then
			vi $value
			return
		fi
	done
	echo "unable to find shell configuration file"
}

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
	for i in $(seq 1 $1); do
		c ..
	done
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
	vi $(awk -F: '{print $1}' <<< "$1")
}

# Use pub to print Ed25519 public key. It will generate a new key if one does
# not exist.
function pub {
	if [[ ! -f ~/.ssh/id_ed25519 ]]; then
		ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" > /dev/null
	fi
	cat ~/.ssh/id_ed25519.pub
}

# Use pubc to print command that can be copied and pasted onto another server to
# add the local public key.
function pubc {
	echo 'mkdir -p ~/.ssh && echo "'$(pub)'" >> ~/.ssh/authorized_keys'
}

# Use sri to print subresource integrity value for file.
function sri {
	digest=$(openssl sha384 -binary "$1" | base64)
	echo "sha384-$digest"
}

# Use mkc to create and change to a directory. Create parent directories if
# necessary.
function mkc {
	mkdir -p "$1" && cd "$1"
}

# Define function to sort directory from smallest to largest.
function lsort {
	if [ "$1" == "" ]; then
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
		pl)
			perl "$@"
			;;
		py)
			python3 "$@"
			;;
		sh)
			bash "$@"
			;;
		*)
			echo unrecognized script extension
			;;
	esac
}

# If Python available, use jfmt to format JSON and phttp to start a HTTP server
# for static files.
if hash python3 2>/dev/null; then
	alias jfmt="python3 -m json.tool"
	alias phttp="python3 -m http.server"
elif hash python 2>/dev/null; then
	alias jfmt="python -m json.tool"
	alias phttp="python -m http.server"
fi

# Define alias for tmux or GNU Screen.
if hash tmux 2>/dev/null; then
	alias t="tmux new-session -t 0 || tmux"
elif hash screen 2>/dev/null; then
	alias t="screen -x || screen"
fi

# If wget is not available but cURL is available (such as on macOS), allow cURL
# to be invoked using the wget command. Include -L to follow redirects.
if ! hash wget 2>/dev/null; then
	if hash curl 2>/dev/null; then
		alias wget="curl -O -L"
	fi
fi

# If apt is available, define related aliases. Some are only necessary of the
# user is root.
if hash apt 2>/dev/null; then
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
if hash go 2>/dev/null; then
	alias gob="go build"
	alias gog="go generate"
	alias got="go test -c"
	alias gotn="got -o /dev/null"
fi

if hash docker 2>/dev/null; then
	source "$(dirname $bashSource)/shell/docker.sh"
fi

if hash git 2>/dev/null; then
	source "$(dirname $bashSource)/shell/git.sh"
fi
