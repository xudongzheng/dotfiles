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
alias gep="git ls-files | ep"
alias gf="git fetch"
alias gg="git fetch && git reset --hard @{u}"
alias gian="git update-index --no-assume-unchanged"
alias giau="git update-index --assume-unchanged"
alias gl="git log --graph --decorate --stat --find-renames --date-order --show-signature"
alias glb="gl --branches --remotes --tags"
alias glf="gl --pretty=fuller"
alias glo="git log --pretty=oneline --abbrev-commit"
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
alias gw="git ls-files | xargs cat | wc -l"
alias gx="git commit"
alias gxa="gx -a"
alias gxar="gaa && gxr"
alias gxm="gx -m"
alias gxn="gx --amend"
alias gxr='gx -m "$(date -R)"'
alias gy="gu && gxar && gp"

# Define functions for working with main/master depending on what is used by the
# project.
function gitma {
	if git show-ref -q --heads main; then
		echo "main"
	else
		echo "master"
	fi
}
function gcm { git checkout $(gitma); }
function gmm { git merge $(gitma); }
function grm { git rebase $(gitma); }
function grim { git rebase -i $(gitma); }

# Define aliases for searching a Git repository. Use -z so Unicode names are not
# escaped. It will also use \x00 as the separator, which is fine since xargs is
# an alias that expects it. This uses "git grep" instead of "git ls-files" since
# the latter includes submodules, which grep will give an error for since they
# are directories. See https://goo.gl/DLz58m for details.
alias lg="git grep -z --cached -l '' | xargs grep --color -n"
alias lgi="lg -i"
alias lgt="lg TODO"
alias lgtt="lg 'TODO TODO'"

# Use gxua to set the repository email address to the default alias email. Use
# gxul to set it to the email of the last commit. We must use single quotes for
# the latter so the inner command is not executed until running the alias.
alias gxua="git config user.email 7pkvm5aw@slicealias.com"
alias gxul='git config user.email $(git log -1 --pretty=format:%ae)'

# Define function to show commit diff. If number given as argument, show diff
# for commit n before HEAD.
function gh {
	if [[ "$1" =~ ^[0-9]+$ ]]; then
		git show HEAD~$1
	else
		git show "$@"
	fi
}

# Define function for synchronizing a repository's commit dates and author
# dates. If no argument is given, consider the last 20 commits. Use either -- or
# HEAD as the second argument to process all branch commits.
function gfb {
	list="$2"
	if [[ $2 == "" ]]; then
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
