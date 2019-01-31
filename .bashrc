# Increase bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

export EDITOR=vim
export TERM=xterm-256color

# Set the limit for open file descriptors to 1024. It should already be the
# default on Linux whereas the default is 256 on macOS.
ulimit -n 1024

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

# Resolve the parent directory. It is commonly where we would find the primary
# src directory.
parent=$(dirname "$(dirname "${BASH_SOURCE[0]}")")

alias autk="vi ~/.ssh/authorized_keys"
alias bhi="vi ~/.bash_history"
alias c="cd"
alias cdot="c '"$(dirname "${BASH_SOURCE[0]}")"'"
alias crt="crontab -e"
alias dfh="df -h"
alias dr="date -R"
alias ep="grep --color"
alias epi="ep -i"
alias epr="ep -R"
alias epri="epr -i"
alias fig="find . | ep"
alias fm="free -m"
alias fms="fm -s 5"
alias gfmt="wfmt '$parent/src'"
alias hig="history | ep"
alias lgr="git ls-files | ep"
alias ll="l -hla"
alias n="netstat -nlp"
alias ng="n | ep"
alias p="ps aux"
alias pg="p | ep"
alias pub="cat ~/.ssh/id_*.pub"
alias skg="ssh-keygen -t ed25519"
alias t="tmux new-session -t 0 || tmux"
alias tm="touch -m"
alias vi="vim"
alias vie="vim -c Explore"
alias viun="vim -u NONE"
alias wfmt="gofmt -w=true -s"
alias wl="wc -l"
alias ws="git ls-files | xargs cat | wc -l"

# Create an alias for cp and mv as to prompt before overwriting existing files.
alias cp="cp -i"
alias mv="mv -i"

# Create aliases for calculating size of directories and files. Use --summarize
# (-s) subdirectories are not calculated separately. Use the -b flag to consider
# the size of the file contents rather than the size used on disk.
alias dubh="du -sbh"
alias duh="du -sh"

# Create aliases for changing to common directories for directories that exists.
function aliasDir {
	if [ -d "$2" ]; then
		alias $1="c '$2'"
	fi
}
aliasDir csr "$parent/src"
aliasDir cde ~/Desktop
aliasDir cdl ~/Downloads
aliasDir cdoc ~/Documents

# Use dqap (like in Vim) to undo line wrapping in a file. Per
# https://goo.gl/PfzvyS, the "fmt" command does not accept widths larger than
# 2500. This appears to be an issue on Linux but not MacOS. If this turns out to
# be an issue, consider using Perl among other alternatives.
function dqap {
	fmt -w 2500 "$@" | sed "s/  / /g"
}

# Use jfmt command to format JSON using Python if Python available.
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
alias ghh="gh HEAD"
alias ghns="gh --name-status"
alias gian="git update-index --no-assume-unchanged"
alias giau="git update-index --assume-unchanged"
alias gl="git log --graph --decorate --stat --find-renames --date-order --show-signature"
alias glb="gl --branches --remotes --tags"
alias glf="gl --pretty=fuller"
alias glo="git log --pretty=oneline"
alias gm="git merge"
alias gma="gm --abort"
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
alias gs="git status"
alias gt="git stash"
alias gta="gt apply"
alias gtp="gt -p"
alias gu="git pull -p"
alias gx="git commit"
alias gxm="gx -m"
alias gxn="gx --amend"
alias gxr='gx -m "$(date -R)"'
alias gy="gu && gaa && gxr && gp"

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

# Define alias for synchronizing a repository's commit dates and author dates.
# If no argument is given, only consider the last 20 commits. Use either -- or
# HEAD as argument to process all branch commits.
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
