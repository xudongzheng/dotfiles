set -e
key="3482E963C87B750D0D65E71BBBF920F2DB00633A"
git fetch
data=$(git verify-commit --raw origin/master 2>&1)
if ! cut -d ' ' -f 2- <<< "$data" | grep -q "VALIDSIG $key"; then
	echo invalid signature
fi
git merge origin/master
