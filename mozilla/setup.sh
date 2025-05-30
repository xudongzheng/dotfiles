set -e

cd "$(dirname "$0")"

function writePref {
	echo "user_pref(\"$2\", $3);" >> "$1/user.js"
}

function handleUserJS {
	application="$1"
	userDir="$2"

	# Clear user.js.
	> "$userDir/user.js"

	# Disable using middle mouse button to paste.
	writePref "$userDir" middlemouse.paste false

	# When using a SOCKS5 proxy, DNS should be handled through the proxy.
	writePref "$userDir" network.proxy.socks_remote_dns true

	if [[ "$application" == "thunderbird" ]]; then
		# Set Thunderbird date format. See https://bit.ly/3Qfbf8n for
		# documentation.
		writePref "$userDir" intl.date_time.pattern_override.date_short '"yyyy-MM-dd"'

		# Set display density to compact.
		writePref "$userDir" mail.uidensity 0

		# Set user interface font size.
		writePref "$userDir" mail.uifontsize 14
	elif [[ "$application" == "firefox" ]]; then
		# Suppress about:config page warning.
		writePref "$userDir" browser.aboutConfig.showWarning false

		# Open previous windows and tabs.
		writePref "$userDir" browser.startup.page 3

		# Configure Firefox home page.
		writePref "$userDir" browser.newtabpage.activity-stream.feeds.section.topstories false
		writePref "$userDir" browser.newtabpage.activity-stream.showSponsoredTopSites false
		writePref "$userDir" browser.newtabpage.activity-stream.topSitesRows 4

		# Do not check if Firefox is the default browser. On macOS, Safari will
		# remain the default browser.
		writePref "$userDir" browser.shell.checkDefaultBrowser false

		# Disable Firefox View.
		writePref "$userDir" browser.tabs.firefox-view false

		# Disable suggestions from sponsors in address bar.
		writePref "$userDir" browser.urlbar.suggest.quicksuggest.sponsored false

		# Always ask where to save download files.
		writePref "$userDir" browser.download.useDownloadDir false

		# When opening a PDF, by default Firefox will download it and open the
		# local file. Have Firefox open it without saving it to a file.
		writePref "$userDir" browser.download.open_pdf_attachments_inline true

		# Do not allow sites to request camera or geolocation permissions by
		# default. Individual sites may still be allowed to request permission
		# by opening Page Info and navigating to Permissions.
		writePref "$userDir" permissions.default.camera 2
		writePref "$userDir" permissions.default.geo 2

		# Disable address and credit card autofill.
		writePref "$userDir" extensions.formautofill.addresses.enabled false
		writePref "$userDir" extensions.formautofill.creditCards.enabled false

		# Disable JavaScript in PDF to prevent things such as alerts.
		writePref "$userDir" pdfjs.enableScripting false

		# Allow unsigned extensions. Per https://bit.ly/3zbAt1o, this only works
		# on the ESR, Developer, and Nightly releases.
		writePref "$userDir" xpinstall.signatures.required false

		# Disable text segmentation for Chinese. Double clicking should select
		# an entire phrase or sentence. Text segmentation makes it more
		# difficult to select names, among other things.
		writePref "$userDir" intl.icu4x.segmenter.enabled false

		# Manage updates manually.
		writePref "$userDir" app.update.auto false

		# Increase Developer Tools font size.
		writePref "$userDir" devtools.toolbox.zoomValue '"1.5"'

		# Warn when closing a window with multiple tabs.
		writePref "$userDir" browser.tabs.warnOnClose true
	fi
}

function handleTBFF {
	tbDir=$1
	ffDir=$2

	tbIni="$tbDir/profiles.ini"
	if [[ -f "$tbIni" ]]; then
		grep Path= "$tbIni" | sed "s/Path=//" | while read line; do
			handleUserJS thunderbird "$tbDir/$line"
		done
	fi

	ffIni="$ffDir/profiles.ini"
	if [[ -f "$ffIni" ]]; then
		grep Path= "$ffIni" | sed "s/Path=//" | while read line; do
			handleUserJS firefox "$ffDir/$line"
		done
	fi
}

uname=$(uname)
if [[ $uname == "Linux" ]]; then
	handleTBFF ~/.thunderbird ~/.mozilla/firefox
elif [[ $uname == "Darwin" ]]; then
	handleTBFF ~/Library/Thunderbird ~/Library/"Application Support"/Firefox
fi
