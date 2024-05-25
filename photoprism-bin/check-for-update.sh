#!/bin/bash

set -e

source ./PKGBUILD

# Use GitHub CLI to get latest release tag
LATEST_RELEASE=$(gh release -R $url view --json tagName --jq '.tagName')

echo "Latest release is $LATEST_RELEASE";
echo "Current version in AUR is $pkgver-$commit";

# Split LATEST_RELEASE into an array using '-' as the delimiter
IFS='-' read -r -a DATE_AND_HASH <<< "$LATEST_RELEASE"

# Extract the release date and hash from the array
RELEASE_DATE=${DATE_AND_HASH[0]}
RELEASE_HASH=${DATE_AND_HASH[1]}

if [ "$RELEASE_DATE" -eq $pkgver ]; then
	echo "$LATEST_RELEASE is the latest version"
	exit 0;
fi

sed -i 's/'${pkgver}'/'"$RELEASE_DATE"'/g' ./PKGBUILD
sed -i 's/'${commit}'/'"$RELEASE_HASH"'/g' ./PKGBUILD
sed -i 's/pkgrel='${pkgrel}'/pkgrel=0/g' ./PKGBUILD

makepkg --nobuild --skipchecksums # Download new files, ignoring checksum because we need to update them.

updpkgsums # Update checksums

makepkg --printsrcinfo > .SRCINFO # Update .SRCINFO

git checkout -b "bump-photoprism-$LATEST_RELEASE"
git commit -a --message "Upgrade photoprism to $LATEST_RELEASE"
git push -f origin "bump-photoprism-$LATEST_RELEASE"

gh pr create --title "Upgrade photoprism to $LATEST_RELEASE" --body "" --reviewer thomaseizinger
