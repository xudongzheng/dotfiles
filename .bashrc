# Define function for creating directory aliases. This is defined before exiting
# for non-interactive sessions since the function may be called from ~/.bashrc.
function aliasDir {
	# When multiple directories are given, create alias for first that exists.
	for dir in "${@:2}"; do
		if [[ -d "$dir" ]]; then
			alias $1="c '$dir'"
			return
		fi
	done
}

# Exit if not interactive, such as when transfering files via scp.
if [[ $- != *i* ]]; then
	return
fi

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

# Define alias for changing to the dotfiles directory. The logic for getting the
# current file path comes from https://bit.ly/33OR2Lh. This works with both Bash
# and Zsh.
dotDir=$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")
aliasDir cdot "$dotDir"

# Set less configuration. A couple arguments are specified using the short form
# rather than long form due to how i3-sensible-pager strips -E and -F
# https://bit.ly/4ekPUmM.
export LESS="-FNRX --chop-long-lines --shift 20 --tabs 4"
export LESSKEYIN=$dotDir/.lesskeyin

# Load shell specific code.
if [[ $SHELL == "/bin/bash" ]]; then
	source "$dotDir/shell/bash.sh"
elif [[ $SHELL == "/bin/zsh" ]]; then
	source "$dotDir/shell/zsh.sh"
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

# Define function to prevent piping to Vim or piping Vim to somewhere. This can
# happen accidentally when working with large amounts of text and using Vim as a
# pager. This comes from https://bit.ly/3FG7m65.
function vi {
	if [[ ! -t 1 ]]; then
		echo "Vim must run with TTY as standard output" >&2
	elif [[ ! -t 0 ]]; then
		echo "Vim must run with TTY as standard input"
	else
		command vi "$@"
	fi
}

# Define function for piping to Vim.
function vid {
	if [[ -t 0 ]]; then
		echo "Vim expecting pipe as standard input"
	else
		command vi -
	fi
}

# Define ping function wrapper to lookup SSH host before pinging.
function ping {
	# Look up host using "ssh" command with the last argument being the host.
	addr="${@: -1}"
	addr=$(ssh -G "$addr" | grep "^hostname " | awk '{print $2}')

	# Call "ping" with the lookup result replacing the last argument.
	args=("$@")
	args[-1]="$addr"
	command ping "${args[@]}"
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

# Set environment variables for using Vim as man pager.
if command -v man > /dev/null; then
	export MANWIDTH=80
	if [[ $uname != "Darwin" ]]; then
		export MANOPT="--no-hyphenation --no-justification"
	fi
	export MANPAGER="sh -c 'col -bx | vi - -c set\ filetype=man'"
fi

# Define aliases for top.
if [[ $uname == "Darwin" ]]; then
	alias tom="top -o mem"
else
	alias top="top -E m -e m -o %CPU"
	alias tom="top -E m -e m -o %MEM"
fi

# Define alias for ps.
if [[ $uname == "Darwin" ]]; then
	alias p="ps aux"
else
	alias p="ps auxf"
fi
alias pg="ps aux | ep"
alias pim="p | vid"

alias autk="vi ~/.ssh/authorized_keys"
alias c="cd"
alias cm="c - > /dev/null"
alias crt="crontab -e"
alias dfh="df -h"
alias ep="grep --color"
alias epi="ep -i"
alias epr="ep -Rn"
alias epri="epr -i"
alias eprtt="epr 'TODO TODO'"
alias fep="find . | ep"
alias fm="free -m"
alias fms="fm -s 1"
alias hig="history | ep"
alias n="netstat -nlp"
alias ng="n | ep"
alias pwdc="pwd | xc"
alias tf="tail -f"
alias tm="touch -m"
alias usm="useradd -s /bin/bash -m"
alias vidi="vimdiff"
alias vie="vi -c Explore"
alias vrc="vi .vimrc"
alias wl="wc -l"
alias xc="bash $dotDir/clipboard/copy.sh"

# The "reset" Bash command takes a full second to run. Use "tput reset" to
# achieve the same functionality without the delay. See https://bit.ly/3An1bo2
# for details.
alias r="tput reset"

# Define realpath function for converting relative path to absolute path. The
# command exists natively in Linux but not macOS.
if [[ $uname == "Darwin" ]]; then
	function realpath {
		echo $(cd $(dirname "$1") && pwd)/$(basename "$1")
	}
fi

alias rp="realpath"
function rpc { rp "$@" | xc; }

# Define aliases for file listing. When sorting by time, default to newest files
# at the end as they are most likely the relevant ones.
alias ll="l -hlA"
alias ltr="ll -t"
alias lt="ll -rt"

# Define alias for cutting words. Use "tr" to squeeze multiple consecutive
# spaces into one. "cutw n" prints the n-th word on every line. "cutw n-" prints
# every word starting from the n-th word on every line.
alias cutw="tr -s ' ' | cut -d ' ' -f"

# Define aliases for sorting. By default, sort using binary. Sorting with
# English locale is useful when the result should be case insensitive. The
# second alias uses "command" so it doesn't call into the first alias.
alias sort="LC_ALL=C sort"
alias sorten="LC_ALL=en_US.UTF-8 command sort"

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
alias tarcf="tar --create --file"
alias tarzcf="tar --gzip --create --file"
alias tarxf="tar --keep-old-files --no-same-permissions --no-same-owner --extract --file"

# Create an alias for cp and mv as to prompt before overwriting existing files.
alias cp="cp -i"
alias mv="mv -i"

# Create function to undo mv. This can be easily used by editing the initial
# "mv" command and adding the "un" prefix. This exists for convenience and
# doesn't handle many cases such as moving multiple files.
function unmv {
	# If destination is a file, swap arguments to undo.
	if [[ -f "$2" ]]; then
		mv -v "$2" "$1"
		return
	fi

	# If destination is a directory, it's not possible to determine with 100%
	# certainty if the previous operation involved renaming or moving. For
	# simplicity, assume move if the destination directory contains an entry
	# matching the source.
	dst="$2/$(basename "$1")"
	if [[ -e "$dst" ]]; then
		mv -v "$dst" "$(dirname "$1")"
	else
		mv -v "$2" "$1"
	fi
}

# Define function to rename file based on modification time.
function mvmod {
	for src in "$@"; do
		ext="${src##*.}"
		dir=$(dirname "$src")
		file=$(date -r "$src" "+%Y-%m-%d %H.%M.%S.$ext")
		dst="$dir/$file"
		mv -v "$src" "$dst"
	done
}

# Create aliases for calculating size of directories and files. Use -s so
# subdirectories are not listed individually. The apparent size alias is useful
# for showing the theoretical size of sparse files instead of the size on disk.
# These are defined with short flags as long flags are not supported on macOS.
alias duh="du -sh"
if [[ $uname == "Darwin" ]]; then
	alias duha="du -sAh"
else
	alias duha="du -sbh"
fi

# Create alias for parsing x509 certificate.
alias osx509="openssl x509 -text -noout -in"

# In WSL2, determine path to native home directory.
if command -v powershell.exe > /dev/null; then
	userHome=/mnt/c/Users/$(powershell.exe -Command 'Write-Host -NoNewline $env:USERNAME')
	aliasDir cw $userHome
else
	userHome=$HOME
fi

# Create aliases for common directories.
aliasDir cde $userHome/Desktop
aliasDir cdl $userHome/Downloads
aliasDir cdoc $userHome/Documents
aliasDir csh ~/.ssh
aliasDir csr ~/src
aliasDir css ~/Documents/screenshot $userHome/Pictures/Screenshots

# If screenshot is organized by month, follow "current" symlink. Otherwise print
# main screenshot directory.
function ssdir {
	current=~/Documents/screenshot/current
	if [[ -e $current ]]; then
		readlink $current
	else
		css
		pwd
		cm
	fi
}

function csd { cd $(ssdir); }

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
	fc
}

# Define xv to rerun the last command and pipe the output to Vim.
function xv {
	# Both standard input and standard output must be TTY and not a pipe.
	# Otherwise display error. This prevents xv from calling xv recursively.
	if [[ -t 1 ]] && [[ -t 0 ]]; then
		fc -s | vid
	else
		echo "xv cannot be used with a pipe"
	fi
}

# Use cdn to go to the directory containing a given file. This makes it easy to
# double click a path in grep output (assuming it does not contain spaces) and
# navigate to the folder containing it.
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

function dotcommit { git -C "$dotDir" rev-parse master; }

# Use dotc to copy the dotfiles commit hash. This is useful for pulling changes
# on machines that lack GPG.
alias dotc="dotcommit | xc"

# Use dotC to print and copy the command for setting up dotfiles on a new server
# or user.
function dotC {
	cmd=""
	if [[ "$1" == "apt" ]]; then
		cmd="apt update && apt install -y git vim tmux && "
	fi
	commit=$(dotcommit)
	cmd+="git clone https://github.com/xudongzheng/dotfiles.git dot && cd dot && git checkout $commit && git branch -f master HEAD && bash setup.sh && exit"
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

# Use pubc to print and copy the local SSH public key.
alias pubc="pub | xc"

# Use pubC to print and copy command for adding the local SSH public key to
# .ssh/authorized_keys.
function pubC {
	cmd='mkdir -p ~/.ssh && echo "'$(pub)'" >> ~/.ssh/authorized_keys'
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
	find "$dir" -mindepth 1 -maxdepth 1 | xargs du -sh | sort -h | column -t -s $'\t'
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
			echo "Failed to recognize script extension"
			;;
	esac
}

# Set tab width to 4 spaces.
tabs -4

# Define function for converting spaces to tabs.
function space2tab {
	width=$1
	if [[ "$width" == "" ]]; then
		width=4
	fi
	perl -pe 's/^( +)/"\t" x (length($1)\/'$width')/e'
}

if command -v python3 > /dev/null; then
	# Define function to format JSON. Indent with tabs instead of spaces.
	function jfmt {
		python3 -m json.tool "$@" | space2tab
	}

	# Define function to format JSON and write output to file.
	function jpretty {
		for file in "$@"; do
			jfmt "$file" > "${file%.json}.pretty.json"
		done
	}

	alias phttp="python3 -m http.server"
fi

# Define alias for tmux or GNU Screen.
if command -v tmux > /dev/null; then
	alias t="tmux new-session -t 0 || tmux"
elif command -v screen > /dev/null; then
	alias t="screen -x || screen"
fi

# If wget is not available but cURL is available such as on macOS, allow cURL to
# be invoked using the wget command.
if ! command -v wget > /dev/null; then
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

function ipa {
	if [[ $uname == "Darwin" ]]; then
		ifconfig | grep -o "^[a-z0-9]\+:" | sed "s/://" | while read ifce; do
			addr=$(ifconfig "$ifce" | grep -w inet | awk '{print $2}')
			if [[ "$addr" != "" ]]; then
				echo -e "$ifce\t$addr"
			fi
		done
	else
		ip -brief addr | while read line; do
			ifce=$(awk '{print $1}' <<< "$line")
			addr=$(awk '{print $3}' <<< "$line" | awk -F / '{print $1}')
			if [[ "$addr" != "" ]]; then
				echo -e "$ifce\t$addr"
			fi
		done
	fi | column -t
}

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
	source "$dotDir/shell/git.sh"
fi

if [[ $uname == "Darwin" ]]; then
	firefox=/Applications/Firefox.app/Contents/MacOS/firefox
else
	firefox=firefox
fi
if command -v $firefox > /dev/null; then
	source "$dotDir/shell/mozilla.sh"
fi
