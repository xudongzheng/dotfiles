set -e

cd "$(dirname "$0")"

function write_pref {
	echo "user_pref(\"$2\", $3);" >> "$1/user.js"
}

function handle_user_js {
	application="$1"
	user_dir="$2"

	# Clear user.js.
	> "$user_dir/user.js"

	# Disable using middle mouse button to paste.
	write_pref "$user_dir" middlemouse.paste false

	if [[ "$application" == "thunderbird" ]]; then
		# Set Thunderbird date format. See https://bit.ly/3Qfbf8n for
		# documentation.
		write_pref "$user_dir" intl.date_time.pattern_override.date_short '"yyyy-MM-dd"'

		# Set display density to compact.
		write_pref "$user_dir" mail.uidensity 0

		# Set user interface font size.
		write_pref "$user_dir" mail.uifontsize 14
	elif [[ "$application" == "firefox" ]]; then
		# Suppress about:config page warning.
		write_pref "$user_dir" browser.aboutConfig.showWarning false

		# Open previous windows and tabs.
		write_pref "$user_dir" browser.startup.page 3

		# Configure Firefox home page.
		write_pref "$user_dir" browser.newtabpage.activity-stream.feeds.section.topstories false
		write_pref "$user_dir" browser.newtabpage.activity-stream.showSponsoredTopSites false
		write_pref "$user_dir" browser.newtabpage.activity-stream.topSitesRows 4

		# Do not check if Firefox is the default browser. On macOS, Safari will
		# remain the default browser.
		write_pref "$user_dir" browser.shell.checkDefaultBrowser false

		# Disable Firefox View.
		write_pref "$user_dir" browser.tabs.firefox-view false

		# Disable suggestions from sponsors in address bar.
		write_pref "$user_dir" browser.urlbar.suggest.quicksuggest.sponsored false

		# Always ask where to save download files.
		write_pref "$user_dir" browser.download.useDownloadDir false

		# When opening a PDF, by default Firefox will download it and open the
		# local file. Have Firefox open it without saving it to a file.
		write_pref "$user_dir" browser.download.open_pdf_attachments_inline true

		# Do not allow sites to request camera or geolocation permissions by
		# default. Individual sites may still be allowed to request permission
		# by opening Page Info and navigating to Permissions.
		write_pref "$user_dir" permissions.default.camera 2
		write_pref "$user_dir" permissions.default.geo 2

		# Disable address and credit card autofill.
		write_pref "$user_dir" extensions.formautofill.addresses.enabled false
		write_pref "$user_dir" extensions.formautofill.creditCards.enabled false

		# Disable JavaScript in PDF to prevent things such as alerts.
		write_pref "$user_dir" pdfjs.enableScripting false

		# Allow unsigned extensions. Per https://bit.ly/3zbAt1o, this only works
		# on the ESR, Developer, and Nightly releases.
		write_pref "$user_dir" xpinstall.signatures.required false

		# Manage updates manually.
		write_pref "$user_dir" app.update.auto false

		# Increase Developer Tools font size.
		write_pref "$user_dir" devtools.toolbox.zoomValue '"1.5"'

		# Warn when closing a window with multiple tabs.
		write_pref "$user_dir" browser.tabs.warnOnClose true
	fi
}

function handle_tbff {
	tb_dir=$1
	ff_dir=$2

	tb_ini="$tb_dir/profiles.ini"
	if [[ -f "$tb_ini" ]]; then
		grep Path= "$tb_ini" | sed "s/Path=//" | while read line; do
			handle_user_js thunderbird "$tb_dir/$line"
		done
	fi

	ff_ini="$ff_dir/profiles.ini"
	if [[ -f "$ff_ini" ]]; then
		grep Path= "$ff_ini" | sed "s/Path=//" | while read line; do
			handle_user_js firefox "$ff_dir/$line"
		done
	fi
}

uname=$(uname)
if [[ $uname == "Linux" ]]; then
	handle_tbff ~/.thunderbird ~/.mozilla/firefox
elif [[ $uname == "Darwin" ]]; then
	handle_tbff ~/Library/Thunderbird ~/Library/"Application Support"/Firefox
fi
