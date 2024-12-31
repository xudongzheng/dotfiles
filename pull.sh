set -e

cd "$(dirname "$0")"

# Fetch remote changes.
git fetch

# If a commit was specified, rebase on top of the specified commit. Otherwise
# rebase on top of the remote master branch if signed with the correct key.
if [[ $1 ]]; then
	git rebase "$1"
elif ! command -v gpg > /dev/null; then
	echo "Unable to verify commit without GPG"
else
	key="3482E963C87B750D0D65E71BBBF920F2DB00633A"
	commit=$(git rev-parse origin/master)
	data=$(git verify-commit --raw $commit 2>&1)
	if ! cut -d ' ' -f 2- <<< "$data" | grep -q "VALIDSIG $key"; then
		echo "Invalid signature detected on commit"
	fi
	git rebase $commit
fi
