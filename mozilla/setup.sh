set -e

cd "$(dirname "$0")"

function writePref {
	echo "user_pref(\"$2\", $3);" >> "$1"
}

function handleUserJS {
	application=$1
	userJS="$2/user.js"

	> "$userJS"

	# Disable using middle mouse button to paste.
	writePref "$userJS" middlemouse.paste false

	if [[ "$application" == "thunderbird" ]]; then
		# Set Thunderbird date format. See https://bit.ly/3Qfbf8n for
		# documentation.
		writePref "$userJS" intl.date_time.pattern_override.date_short '"yyyy-MM-dd"'
	elif [[ "$application" == "firefox" ]]; then
		# Configure Firefox home page.
		writePref "$userJS" browser.newtabpage.activity-stream.feeds.section.topstories false
		writePref "$userJS" browser.newtabpage.activity-stream.showSponsoredTopSites false
		writePref "$userJS" browser.newtabpage.activity-stream.topSitesRows 4

		# Do not check if Firefox is the default browser. On macOS, Safari will
		# remain the default browser.
		writePref "$userJS" browser.shell.checkDefaultBrowser false

		# Disable Firefox View.
		writePref "$userJS" browser.tabs.firefox-view false
	fi
}

function handleTBFF {
	tbDir=$1
	ffDir=$2
	grep Path= "$tbDir/profiles.ini" | sed "s/Path=//" | while read line; do
		handleUserJS thunderbird "$tbDir/$line"
	done
	grep Path= "$ffDir/profiles.ini" | sed "s/Path=//" | while read line; do
		handleUserJS firefox "$ffDir/$line"
	done
}

uname=$(uname)
if [[ $uname == "Linux" ]]; then
	handleTBFF ~/.thunderbird ~/.mozilla/firefox
elif [[ $uname == "Darwin" ]]; then
	handleTBFF ~/Library/Thunderbird ~/Library/"Application Support"/Firefox
fi
