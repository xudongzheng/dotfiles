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
alias gps="gp --set-upstream"
alias gpso="gps origin"
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
alias gxar="gaa && gxr"
alias gxm="gx -m"
alias gxn="gx --amend"
alias gxr='gx -m "$(date -R)"'
alias gxs="gx --signoff"
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
function glm { git log $(gitma); }
function gmm { git merge $(gitma); }
function grim { git rebase -i $(gitma); }
function griom { git rebase -i origin/$(gitma); }
function grm { git rebase $(gitma); }
function grom { git rebase origin/$(gitma); }

# Define aliases for processing Git repository content. Use -z so Unicode names
# are not escaped. The flag also changes the separator to \x00, which is fine
# since xargs is an alias that already expects it. Use "git grep" instead of
# "git ls-files" since the latter includes submodules. which should be ignored
# since these aliases are for files. See https://goo.gl/DLz58m for details.
alias gw="git grep -z --cached -l '' | xargs cat | wc -l"
alias lg="git grep -z --cached -l '' | xargs grep --color -n"
alias lgi="lg -i"
alias lgt="lg TODO"
alias lgtt="lg 'TODO TODO'"

# Define alias for searching filenames in a Git repository. Use -z so Unicode
# names are not escaped. As that also changes the separator to 0x00, convert
# back to \n before grepping.
alias gep="git ls-files -z | sed 's/\x00/\n/g' | ep"

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
		echo Git hostname is not recognized
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
		echo Key for $service $user/$repo already exists
	fi

	echo git@$host:$user/$repo.git
	cat $key.pub
}
