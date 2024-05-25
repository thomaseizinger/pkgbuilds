#!/usr/bin/env bash

set -e

source ./PKGBUILD

# Use GitHub CLI to get latest release tag
LATEST_RELEASE=$(gh release -R $url view --json tagName --jq '.tagName')

echo "Latest release is $LATEST_RELEASE" >&2
echo "Current version in AUR is $pkgver" >&2

if [ "$LATEST_RELEASE" == "$pkgver" ]; then
	echo "$LATEST_RELEASE is the latest version" >&2
	exit 1;
fi

echo "$LATEST_RELEASE";