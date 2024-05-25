#!/usr/bin/env bash

set -e

source ./PKGBUILD

# Use GitHub CLI to get latest release tag
LATEST_RELEASE=$(gh release -R $url view --json tagName --jq '.tagName')

echo "Latest release is $LATEST_RELEASE" >&2
echo "Current version in AUR is $pkgver-$commit" >&2

readarray -d '-' -t DATE_AND_HASH<<<"$LATEST_RELEASE"

RELEASE_DATE=$(python -c 'print("'"$LATEST_RELEASE"'".split("-")[0])')
RELEASE_HASH=$(python -c 'print("'"$LATEST_RELEASE"'".split("-")[1])')

if [ "$RELEASE_DATE" -eq $pkgver ]; then
	echo "$LATEST_RELEASE is the latest version" >&2
	exit 0;
fi

sed -i 's/'${pkgver}'/'"$RELEASE_DATE"'/g' ./PKGBUILD
sed -i 's/'${commit}'/'"$RELEASE_HASH"'/g' ./PKGBUILD

echo "$RELEASE_DATE";
