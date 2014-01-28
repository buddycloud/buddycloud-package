#!/bin/bash

PROJECT_NAME=$1
IS_DEB_PROJECT=$2
DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"

# Source config
source "$CURRENT_DIR/settings.production"

DEPLOY_USER_AT_HOST=$DEPLOY_DOCKER_USER@$DEPLOY_DOCKER_HOST

# Get latest changes for buddycloud-package
ssh $DEPLOY_USER_AT_HOST "cd $PACKAGE_PROJECT; git pull"

# Docker folder
DOCKER_PROJECT=$PACKAGE_PROJECT/projects/$PROJECT_NAME/docker

# Copy latest DEB file
if $IS_DEB_PROJECT; then
  LATEST_DEB=$(ls -t *.deb | head -n 1)
  scp $LATEST_DEB $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$PROJECT_NAME.deb
fi

# Build docker
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; docker build ."

