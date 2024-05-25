#!/bin/bash

set -e

source ./PKGBUILD

# Use GitHub CLI to get latest release tag
LATEST_RELEASE=$(gh release -R $url view --json tagName --jq '.tagName')

echo "Latest release is $LATEST_RELEASE";
echo "Current version in AUR is $pkgver-$commit";

readarray -d '-' -t DATE_AND_HASH<<<"$LATEST_RELEASE"

RELEASE_DATE=$(python -c 'print("'"$LATEST_RELEASE"'".split("-")[0])')
RELEASE_HASH=$(python -c 'print("'"$LATEST_RELEASE"'".split("-")[1])')

if [ $RELEASE_DATE -eq $pkgver ]; then
	echo "$LATEST_RELEASE is the latest version"
	exit 0;
fi

sed -i 's/'${pkgver}'/'"$RELEASE_DATE"'/g' ./PKGBUILD ./.SRCINFO
sed -i 's/'${commit}'/'"$RELEASE_HASH"'/g' ./PKGBUILD ./.SRCINFO
sed -i 's/pkgrel = '${pkgrel}'/pkgrel = 0/g' ./.SRCINFO
sed -i 's/pkgrel='${pkgrel}'/pkgrel=0/g' ./PKGBUILD

makepkg --nobuild --skipchecksums # Download new files, ignoring checksum because we need to update them.

updpkgsums # Update checksums

makepkg --printsrcinfo > .SRCINFO # Update .SRCINFO

git checkout -b "bump-photoprism-$LATEST_RELEASE"
git commit -a --message "Upgrade photoprism to $LATEST_RELEASE"
git push -f origin "bump-photoprism-$LATEST_RELEASE"

gh pr create --title "Upgrade photoprism to $LATEST_RELEASE" --body "" --reviewer thomaseizinger
