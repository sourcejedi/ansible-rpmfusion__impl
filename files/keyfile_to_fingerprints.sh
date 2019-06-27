#!/bin/bash
set -e
set -o pipefail

# https://unix.stackexchange.com/questions/335669/gnupg-2-1-16-with-fingerprint-no-longer-works-to-show-fingerprints/393975
# We should use machine-readable output `--with-colons`,
# except it doesn't work (see answer in link)

gpg_show_fingerprints() {
	RC=0
	gpg --with-fingerprint --import-options import-show --dry-run --import < "$1" >/dev/null 2>&1 || RC=$?
	if [ $RC == 2 ]; then
		# Usage error.  Try the old way.
		gpg --with-fingerprint "$1"
	else
		gpg --with-fingerprint --import-options import-show --dry-run --import < "$1"
	fi
}

gpg_show_fingerprints "$1" |
	sed -E -n -e 's/.*(([0-9A-F]{4}[ ]*){10,}).*/\1/ p' |
	sort

# Fingerprints are sorted, for easy comparison
