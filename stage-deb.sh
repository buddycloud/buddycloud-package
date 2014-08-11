#!/bin/bash

P_USER=$1
P_HOST=$2
P_TAG=$3

RELEASE=$(ls -t *.dsc | head -1 | rev | cut -d'.' -f2- | rev)
PACKAGE=$(echo $RELEASE | cut -d'_' -f1)
TARGET_DIR="/var/web/downloads.buddycloud.com/packages/debian/$P_TAG/$PACKAGE/$RELEASE"

ssh $P_USER@$P_HOST mkdir -p $TARGET_DIR
scp *$RELEASE* $P_USER@$P_HOST:$TARGET_DIR
