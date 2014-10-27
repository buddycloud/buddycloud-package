#!/bin/bash

P_USER=$1
P_HOST=$2
P_TAG=$3

RELEASE=$(ls -t *.dsc | head -1 | rev | cut -d'.' -f2- | rev)
PACKAGE=$(echo $RELEASE | cut -d'_' -f1)
TARGET_DIR="/var/web/downloads.buddycloud.com/packages/debian/$P_TAG/$PACKAGE/$RELEASE"

tar -cvf $RELEASE.tar *$RELEASE*
scp $RELEASE.tar $P_USER@$P_HOST:~
ssh $P_USER@$P_HOST "mkdir -p $TARGET_DIR; tar -xvf ~/$RELEASE.tar -C $TARGET_DIR; \
  ln -fs $TARGET_DIR/*.deb $TARGET_DIR/../${PACKAGE}_latest.deb; rm ~/$RELEASE.tar"
rm $RELEASE.tar

