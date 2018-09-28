# Increase bash history size.
HISTSIZE=100000
HISTFILESIZE=200000

# Store timestamp with history.
HISTTIMEFORMAT="[%F %T %Z] "

# Ignore consecutive duplicate commands and commands starting with a space.
HISTCONTROL=erasedups:ignorespace

export EDITOR=vim
export TERM=xterm-256color

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

# Resolve the parent directory.
parent=$(printf %q "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")

# Create an alias for cp and mv as to prompt before overwriting existing files.
alias cp="cp -i"
alias mv="mv -i"

alias autk="vi ~/.ssh/authorized_keys"
alias bhi="vi ~/.bash_history"
alias c="cd"
alias cdot="c $parent/dot/"
alias csr="c $parent/src/"
alias cte="crontab -e"
alias dr="date -R"
alias dush="du -sh"
alias ep="grep"
alias epi="grep -i"
alias epri="grep -Ri"
alias fm="free -m"
alias fms="fm -s 5"
alias gfmt="wfmt $parent/src"
alias hig="history | grep"
alias lg="git ls-files | xargs grep --color -n"
alias lgi="lg -i"
alias lgr="git ls-files | grep"
alias lgt="lg TODO"
alias lgtt="lg 'TODO TODO'"
alias ll="l -hla"
alias n="netstat -nlp"
alias ng="n | grep"
alias p="ps aux"
alias pg="p | grep "
alias pub="cat ~/.ssh/id_*.pub"
alias skg="ssh-keygen -t ed25519"
alias t="tmux new-session -t 0 || tmux"
alias vi="vim"
alias vie="vim -c Explore"
alias viun="vim -u NONE"
alias wfmt="gofmt -w=true -s"
alias wl="wc -l"
alias ws="git ls-files | xargs cat | wc -l"

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
alias gl="git log --graph --decorate --stat --find-renames --date-order"
alias glb="gl --branches --remotes --tags"
alias glol="git log --pretty=oneline"
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
alias gxue='git config user.email $(git log -1 --pretty=format:%ae)'
alias gy="gu && gaa && gxr && gp"

function gfb {
	git filter-branch --env-filter "$1" -f HEAD~20...HEAD
}
function gfad {
	gfb 'GIT_AUTHOR_DATE=$GIT_COMMITTER_DATE; export GIT_AUTHOR_DATE'
}
function gfcd {
	gfb 'GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE; export GIT_COMMITTER_DATE'
}

function grih {
	gr -i "HEAD~$1"
}
