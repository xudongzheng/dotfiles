alias ga="git add"
alias gaa="ga -A"
alias gap="ga -p"

alias gb="git branch"
alias gba="gb -a"
alias gbD="gb -D"

alias gc="git checkout"
alias gcb="gc -b"
alias gcb="gc -b"
alias gcdd="gc --"
alias gcfh="gc FETCH_HEAD"

alias gC="git clone"

# Define function for "git diff". If output is terminal, include --no-prefix so
# it's easier to select and copy the path using the mouse. If output is a file,
# include prefix so the output can be used with "git apply".
function gd {
	if [[ -t 1 ]]; then
		git diff --find-copies --no-prefix "$@"
	else
		git diff --find-copies "$@"
	fi
}

# Define "git show" just like "git diff".
function gh {
	if [[ -t 1 ]]; then
		git show --no-prefix "$@"
	else
		git show "$@"
	fi
}

alias gdc="gd --cached"
alias gdck="gdc --check"
alias gdcs="gdc --stat"
alias gdk="gd --check"
alias gds="gd --stat"

# Often I search with grep before using "git blame". Allow the double click path
# to be copied and used directly.
function ge {
	file=$(cut -d : -f 1 <<< "$1")
	git blame "$file"
}

alias gf="git fetch"
alias gft="gf --tags -f"
alias gfr="gf && git reset --hard @{u}"

# Define function for fetching a GitHub branch from the URL.
function gfg {
	repo=$(sed 's/\/tree\//.git /' <<< $1)
	gf $repo
}

alias gian="git update-index --no-assume-unchanged"
alias giau="git update-index --assume-unchanged"

# Define alias for copying the HEAD commit hash.
alias glc="git rev-parse HEAD | xc"

# Define aliases for the long form of "git log".
alias gl0="git log --graph --decorate --stat --find-renames --date-order --show-signature --pretty=fuller"
alias gl1="gl0 -1"
alias gl="gl0 --max-count=50"
alias gla="gl --branches --remotes --tags"

# Define aliases for the single-line form of "git log".
alias glo0="git log --pretty=oneline --abbrev-commit"
alias glo="glo0 --max-count=1000"

alias gm="git merge"
alias gma="gm --abort"

# Define alias for deleting untracked and ignored files. The first alias lists
# the affected files and directories. The second alias does the deleting.
alias gn="git clean -d -x -n"
alias gnf="git clean -d -x -f"

alias gp="git push"
alias gpf="gp --force"
alias gps="gp --set-upstream"
alias gpso="gps origin"

alias gr="git rebase"
alias gra="gr --abort"
alias grc="gr --continue"
alias gri="gr -i"
alias grifh="gr -i FETCH_HEAD"
alias grs="gr --skip"

alias grh="git reset HEAD"
alias grhc="git reset HEAD^"

alias gR="git remote -v"
alias gRa="git remote add"
alias gRr="git remote remove"

alias gs="git status"

alias gt="git stash"
alias gta="gt apply"
alias gtp="gt -p"

alias gT="git tag"
alias gTd="git tag -d"

alias gu="git pull --prune --tags"

alias gx="git commit"
alias gxa="gx -a"
alias gxn="gx --amend"
alias gxan="gaa && gxn"
alias gxr='gx -m "$(date -R)"'
alias gxar="gaa && gxr"
alias gxs="gx --signoff"

alias gy="gu && gxar && gp"

function gitbr {
	for branch in "$@"; do
		if git show-ref -q --heads "$branch"; then
			echo "$branch"
		fi
	done
}

# Define aliases for checking out common branches.
function gcd { git checkout $(gitbr develop dev); }
function gcp { git checkout $(gitbr production prod); }
function gcs { git checkout $(gitbr staging); }

# Define functions for working with main/master depending on what is used by the
# project.
alias gitma="gitbr main master"
function gcm { git checkout $(gitma); }
function glm { gl $(gitma); }
function gmm { git merge $(gitma); }
function grim { git rebase -i $(gitma); }
function griom { git rebase -i origin/$(gitma); }
function grm { git rebase $(gitma); }
function grom { git rebase origin/$(gitma); }

# Define function for listing repository files for searching. Use "git grep"
# instead of "git ls-files" since the latter includes submodules. which should
# be excluded. See https://goo.gl/DLz58m for details. Use -z so Unicode
# filenames are not escaped. The flag changes the separator to \x00, which is
# fine since this is designed for use with xargs. If Git LFS is installed,
# exclude tracked files.
function gL0 {
	if command -v git-lfs > /dev/null; then
		git grep -z --cached -l "" | grep --null-data -vFf <(s $dotDir/python/git_ls_lfs.py)
	else
		git grep -z --cached -l ""
	fi
}

# Define alias for listing repository files for viewing or manually processing.
# This does not use gL0 since "git grep" excludes empty files.
alias gL="git ls-files"

# Define aliases for searching a Git repository. The flag also changes the separator to \x00, which is fine since
# xargs is an alias that already expects it.
function lg {
	gL0 | xargs grep --color -n "$@" --
}
alias lgi="lg -i"
alias lgt="lg TODO"
alias lgtt="lg 'TODO TODO'"

# Define aliases for counting lines in a Git repository.
alias gw="gL0 | xargs cat | wc -l"
alias gW="gL0 | xargs cat | grep -v ^$ | wc -l"

# Define alias for searching filenames in a Git repository. Use -z so Unicode
# names are not escaped. As that also changes the separator to 0x00, convert
# back to \n before grepping.
alias gep="git ls-files -z | tr '\0' '\n' | ep"

# Use gxua to set the repository email address to the default alias email. Use
# gxul to set it to the email of the last commit. We must use single quotes for
# the latter so the inner command is not executed until running the alias.
alias gxua="git config user.email 7pkvm5aw@slicealias.com"
alias gxul='git config user.email $(git log -1 --pretty=format:%ae)'

# Define function to show diff for commit relative to HEAD.
function ghh {
	git show HEAD~$1
}

# Define function for synchronizing a repository's commit dates and author
# dates. If no argument is given, consider the last 20 commits. Use either -- or
# HEAD as the second argument to process all branch commits.
function gfb {
	list="$2"
	if [[ ! $2 ]]; then
		list="HEAD~20...HEAD"
	fi
	FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --env-filter "$1" -f "$list"
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

# Define function to generate custom SSH keypair for a Git repository. This is
# necessary since services like GitHub only allow each deploy key to be
# associated with one repository. This makes it easier to manage multiple keys
# for multiple repositories.
function gitdk {
	repo=$1
	str=$(sed "s/[@:]/\//g" <<< $1 | sed "s/\.git//")
	hostname=$(cut -d / -f 2 <<< $str)
	user=$(cut -d / -f 3 <<< $str)
	repo=$(cut -d / -f 4 <<< $str)

	if [[ "$hostname" == "github.com" ]]; then
		service=github
	else
		echo "Git hostname is not recognized"
		return
	fi

	# If key does not yet exist, generate SSH key and add custom host to
	# configuration file.
	key=~/.ssh/id_ed25519.$service.$user.$repo
	host=$repo.$user.$service.internal
	if [[ ! -f "$key" ]]; then
		ssh-keygen -t ed25519 -f $key -N "" > /dev/null

		# If configuration file exists, include empty line between hosts.
		if [[ -f ~/.ssh/config-git ]]; then
			echo >> ~/.ssh/config-git
		fi

		echo "Host $host" >> ~/.ssh/config-git
		echo -e "\tHostName $hostname" >> ~/.ssh/config-git
		echo -e "\tIdentityFile $key" >> ~/.ssh/config-git
	else
		echo "Key for $service $user/$repo already exists"
	fi

	cat $key.pub | xc

	inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
	if [[ "$inside_git_repo" ]]; then
		echo "Enter remote name to add remote or press Ctrl-C to quit"
	else
		echo "Press enter to clone or press Ctrl-C to quit"
	fi
	if [[ $SHELL == "/bin/bash" ]]; then
		read -r remote
	elif [[ $SHELL == "/bin/zsh" ]]; then
		read -r "remote?"
	fi
	repo="git@$host:$user/$repo.git"
	if [[ "$inside_git_repo" ]]; then
		git remote add $remote $repo
	else
		git clone $repo
	fi
}
