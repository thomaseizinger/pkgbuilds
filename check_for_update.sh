#!/bin/bash

PACKAGE=$1

# PKGBUILDs are valid shells scripts :lovestruck:
source $PACKAGE/PKGBUILD

# Import semver comparison, silence errors we don't care about
source ./semver2.sh 2> /dev/null

# Use GitHub CLI to get latest release tag
LATEST_RELEASE=$(gh release -R $url view --json tagName --jq '.tagName')
LATEST_RELEASE=$(removeLeadingV $LATEST_RELEASE)

NEEDS_UPDATE=$(semver_compare $LATEST_RELEASE $pkgver)

if [ $NEEDS_UPDATE -lt 1 ]; then
	echo "$LATEST_RELEASE is the latest version"
	exit 0;
fi

gh issue create --title "Update $PACKAGE to $LATEST_RELEASE" --body "$url/releases/latest" --assignee thomaseizinger
