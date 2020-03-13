export TERM=xterm-256color

# Set default editor. On most platforms, Vi and Vim both refer to the same
# editor. When using Ctrl-X Ctrl-E, Zsh tries to advance the cursor to the same
# position as it was in terminal, which is not the behavior that we want. Per
# https://bit.ly/2PZ3iVn, Zsh does this with Vim but not Vi.
export EDITOR=vi

# Increase bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

# Python pip can install packages without root into ~/.local/bin. If such
# directory exists, add it to $PATH.
if [ -d ~/.local/bin ]; then
	PATH=~/.local/bin:$PATH
fi

if [[ $SHELL == "/bin/zsh" ]]; then
	# Setup Ctrl-X Ctrl-E for editing active command in Zsh. This is not ideal
	# as it requires an additional Enter to execute after editing in Vim.
	autoload -U edit-command-line
	zle -N edit-command-line
	bindkey '^x^e' edit-command-line

	# use the same prompt format as Bash on Linux.
	PROMPT="%n@%m:%~$ "
fi

# The ls command is different on Linux and macOS. Set color scheme for macOS
# per https://goo.gl/1ps44T.
uname=$(uname)
if [[ $uname == "Darwin" ]]; then
	export CLICOLOR=1
	export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
	alias l="ls"
else
	alias l="ls --group-directories-first --color=auto"
fi

if [[ $uname == "CYGWIN_NT-10.0" ]]; then
	alias cu="cd /cygdrive/c/Users/$USER"

	# Set $CC to use the MinGW GCC.
	export CC="$(uname -m)-w64-mingw32-gcc"

	# Set $LOCALAPPDATA so Go 1.10 can correctly determine the cache directory
	# (though there are other applications as well).
	export LOCALAPPDATA='C:\Users\'$USER'\AppData\Local'

	# Per https://goo.gl/bSedxZ, create native symlinks.
	export CYGWIN="winsymlinks:nativestrict"
fi

alias autk="vi ~/.ssh/authorized_keys"
alias bhi="vi ~/.bash_history"
alias brc="vi .bashrc"
alias c="cd"
alias crt="crontab -e"
alias dfh="df -h"
alias dr="date -R"
alias ep="grep --color"
alias epi="ep -i"
alias epr="ep -Rn"
alias epri="epr -i"
alias eprtt="epr 'TODO TODO'"
alias fep="find . | ep"
alias fm="free -m"
alias fms="fm -s 5"
alias hig="history | ep"
alias lgr="git ls-files | ep"
alias ll="l -hla"
alias n="netstat -nlp"
alias ng="n | ep"
alias p="ps aux"
alias pg="p | ep"
alias t="tmux new-session -t 0 || tmux"
alias tm="touch -m"
alias usm="useradd -s /bin/bash -m"
alias vi="vim"
alias vie="vi -c Explore"
alias vrc="vi .vimrc"
alias wl="wc -l"
alias ws="git ls-files | xargs cat | wc -l"

# Use dfmt to format Go code using gofmt. Use wfmt to format it in the working
# directory. Use gfmt to do it across the entire Git repository.
alias dfmt="gofmt -w=true -s"
alias wfmt="dfmt ."
alias gfmt='dfmt $(git rev-parse --show-toplevel)'

# Define alias for insecure SSH. This is useful before we reserve a static IP
# for a new device. Generally we use SSH for authentication so there's no real
# security risk.
alias sins="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias sinsr="sins -l root"

# Define aliases for working with tar. The command when running as root on Linux
# and macOS by default will maintain the file owner and permission if possible.
# In particular, extracted files may retain the setuid/setgid attributes. When
# untrusted files are extracted to a public location, users may run the binary
# as other users.
alias tarcf="tar cf"
alias tarzcf="tar zcf"
if [[ $uname == "Darwin" ]]; then
	alias tarxf="tar xfo"
else
	alias tarxf="tar --no-same-permissions -xf"
fi

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

# Create aliases for changing to common directories for directories that exists.
function aliasDir {
	if [ -d "$2" ]; then
		alias $1="c '$2'"
	fi
}
aliasDir cde ~/Desktop
aliasDir cdl ~/Downloads
aliasDir cdoc ~/Documents
aliasDir cgo "$GOROOT"
aliasDir csh ~/.ssh

# Define alias for changing to the dotfiles directory. See
# https://bit.ly/33OR2Lh for way to get the path of this file in Bash and Zsh.
dotDir=$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")
aliasDir cdot "$dotDir"

# In some environments, there will be a src directory in the same directory as
# the dotfiles directory. Use csr to change to it if it exists.
aliasDir csr "$dotDir/../src"

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
	if [ "$count" == "" ]; then
		count=1
	fi
	for i in $(seq 1 $1); do
		c ..
	done
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
	if [ ! -f ~/.ssh/id_ed25519 ]; then
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

# On MacOS where the shasum command is used for the entire SHA family, define
# aliases so we can use the same commands as Linux. Similarly alias md5sum.
if ! hash shasum 2>/dev/null; then
	alias md5sum="md5"
	alias sha1sum="shasum"
	alias sha224sum="shasum -a 224"
	alias sha256sum="shasum -a 256"
	alias sha384sum="shasum -a 384"
	alias sha512sum="shasum -a 512"
fi

# Use jfmt to format JSON using Python if Python available.
if hash python3 2>/dev/null; then
	alias jfmt="python3 -m json.tool"
elif hash python 2>/dev/null; then
	alias jfmt="python -m json.tool"
fi

# If wget is not available but cURL is available (likely on macOS), allow cURL
# to be invoked using the wget command. Include -L to follow redirects.
if ! hash wget 2>/dev/null; then
	if hash curl 2>/dev/null; then
		alias wget="curl -O -L"
	fi
fi

# On macOS, define alias to quickly enable and disable the system-wide SOCKS
# proxy when using WiFi. To enable and disable, use "nswfon" and "nswfoff"
# respectively.
if ! hash networksetup 2>/dev/null; then
	alias nswf="networksetup -setsocksfirewallproxystate Wi-Fi"
	alias nswfon="nswf on"
	alias nswfoff="nswf off"
fi

# If apt-get is available, define related aliases. Some are only necessary of
# the user is root.
if hash apt-get 2>/dev/null; then
	if [ "$USER" == "root" ]; then
		alias ag="apt-get"
		alias agar="ag autoremove"
		alias agd="ag update"
		alias agg="ag upgrade"
		alias agi="ag install"
		alias agr="ag remove"
		alias agu="agd && agg"

		# Use ags instead of acs for "apt-cache search" since c and s use the
		# same finger.
		alias ags="apt-cache search"
	fi

	# Use ali to list all installed packages. This writes standard error of "apt
	# list" to /dev/null since it give a warning about not having a stable CLI
	# interface when the output goes to a pipe instead of a terminal.
	alias ali="apt list --installed 2>/dev/null"
	alias aliep="ali | ep"
fi

# Define aliases for Go.
alias gob="go build"
alias gog="go generate"
alias got="go test -c"
alias gotn="got -o /dev/null"

# Define basic aliases for Git.
alias ga="git add"
alias gaa="ga -A"
alias gap="ga -p"
alias gb="git branch"
alias gba="gb -a"
alias gbhd="gb -D"
alias gc="git checkout"
alias gcb="gc -b"
alias gcdd="gc --"
alias gd="git diff --find-copies"
alias gdc="gd --cached"
alias gdck="gdc --check"
alias gdcs="gdc --stat"
alias gdk="gd --check"
alias gds="gd --stat"
alias ge="git blame"
alias gf="git fetch"
alias gg="git fetch && git reset --hard @{u}"
alias gh="git show"
alias ghns="gh --name-status"
alias gian="git update-index --no-assume-unchanged"
alias giau="git update-index --assume-unchanged"
alias gl="git log --graph --decorate --stat --find-renames --date-order --show-signature"
alias glb="gl --branches --remotes --tags"
alias glf="gl --pretty=fuller"
alias glo="git log --pretty=oneline"
alias glom="gl origin/master"
alias gm="git merge"
alias gma="gm --abort"
alias gn="git clone"
alias gnfd="git clean -f -d"
alias gp="git push"
alias gpf="gp --force"
alias gpo="gp --set-upstream origin"
alias gr="git rebase"
alias gra="gr --abort"
alias grc="gr --continue"
alias grh="git reset HEAD"
alias grhc="git reset HEAD^"
alias gri="gr -i"
alias grs="gr --skip"
alias grv="git remote -v"
alias gs="git status"
alias gt="git stash"
alias gta="gt apply"
alias gtp="gt -p"
alias gu="git pull -p"
alias gx="git commit"
alias gxa="gx -a"
alias gxm="gx -m"
alias gxn="gx --amend"
alias gxr='gx -m "$(date -R)"'
alias gxar="gaa && gxr"
alias gy="gu && gxar && gp"

# Define aliases for searching a Git repository. Replace \n with \x00 so xargs
# correctly handles files with a space in their name. Per https://goo.gl/DLz58m,
# this uses "git grep" instead of "git ls-files" since the latter includes
# submodules that are directories, which grep will give an error for.
alias lg="git grep --cached -l '' | tr '\n' '\0' | xargs -0 grep --color -n"
alias lgi="lg -i"
alias lgt="lg TODO"
alias lgtt="lg 'TODO TODO'"

# Use gxua to set the repository email address to the default alias email. Use
# gxul to set it to the email of the last commit. We must use single quotes for
# the latter so the inner command is not executed until running the alias.
alias gxua="git config user.email 7pkvm5aw@slicealias.com"
alias gxul='git config user.email $(git log -1 --pretty=format:%ae)'

# Define function to show commit diff relative to HEAD.
function ghh {
	if [ "$1" == "" ]; then
		gh HEAD
	else
		gh HEAD~$1
	fi
}

# Define function for synchronizing a repository's commit dates and author
# dates. If no argument is given, consider the last 20 commits. Use either -- or
# HEAD as the second argument to process all branch commits.
function gfb {
	list="$2"
	if [ "$2" == "" ]; then
		list="HEAD~20...HEAD"
	fi
	git filter-branch --env-filter "$1" -f "$list"
}
function gfad {
	gfb 'GIT_AUTHOR_DATE=$GIT_COMMITTER_DATE; export GIT_AUTHOR_DATE' "$1"
}
function gfcd {
	gfb 'GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE; export GIT_COMMITTER_DATE' "$1"
}

function grih {
	gr -i "HEAD~$1"
}
