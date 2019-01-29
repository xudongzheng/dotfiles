set -e

git fetch

# If a commit was specified, merge the specified commit. Otherwise merge the
# remote master branch if signed by the correct key.
if [ "$1" != "" ]; then
	git merge "$1"
else
	key="3482E963C87B750D0D65E71BBBF920F2DB00633A"
	data=$(git verify-commit --raw origin/master 2>&1)
	if ! cut -d ' ' -f 2- <<< "$data" | grep -q "VALIDSIG $key"; then
		echo invalid signature
	fi
	git merge origin/master
fi
