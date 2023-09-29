set -e

cd "$(dirname "$0")"

git push origin master "$@"
