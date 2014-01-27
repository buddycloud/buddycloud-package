#!/bin/bash 
set -e

# Global jenkins building script for buddycloud projects.
# It is called by a jenkins github hook.

# Build variables
DEBFULLNAME="Abmar Barros (buddycloud Packaging)"
DEBEMAIL="abmar@buddycloud.com"

DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"

DATE=$(date +%Y%m%d)
DATE_REPR=$(date -R)

PACKAGE=$1

echo "Processing project $PACKAGE"

# Changelog
GIT_PATH=git
cd $GIT_PATH
REV="$(git log -1 --pretty=format:%h)"

if [ ! -f ../prev.rev ]; then
  git log --max-parents=0 HEAD --pretty=format:%h > ../prev.rev
fi

REV_PREV="$(cat ../prev.rev)"

# Check contrib in
cp -r $CURRENT_DIR/projects/$PACKAGE/debian .

# Convert svn changelog into deb changelog.
# Strip duplicate blank lines too
CHANGELOG="$(git log $REV_PREV..$REV --pretty=format:'[ %an ]%n>%s' | $CURRENT_DIR/gitcl2deb.sh)"

BUILD_VERSION="${DATE}.git.${REV}"
DIST_REVISION="${BUILD_VERSION}-1"
DIST=all

echo -e "${PACKAGE} (${DIST_REVISION}) ${DIST}; urgency=low\n\n\
${CHANGELOG}\n\n\
 -- ${DEBFULLNAME} <${DEBEMAIL}>  ${DATE_REPR}\n"\
> debian/changelog

SOURCE="${PACKAGE}-${BUILD_VERSION}"
ORIG_TGZ="${PACKAGE}_${BUILD_VERSION}.orig.tar.gz"
echo "Building orig.tar.gz ..."
git archive --format=tar "--prefix=${SOURCE}/" "${REV}" | gzip >"../${ORIG_TGZ}"

# Build deb
debuild
