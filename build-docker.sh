#!/bin/bash

PROJECT_NAME=$1
BUILD_ENV=$2
STAGE_DEB=$3
DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"

# Source config
source "$CURRENT_DIR/settings.$BUILD_ENV"

DEPLOY_USER_AT_HOST=$DEPLOY_DOCKER_USER@$DEPLOY_DOCKER_HOST

# Get latest changes for buddycloud-package
ssh $DEPLOY_USER_AT_HOST "cd $PACKAGE_PROJECT; git pull"

# Docker folder
DOCKER_PROJECT=$PACKAGE_PROJECT/projects/$PROJECT_NAME/docker

# Copy latest DEB file
if $STAGE_DEB; then
  LATEST_DEB=$(ls -t *.deb | head -n 1)
  scp $LATEST_DEB $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$PROJECT_NAME.deb
fi

# Build docker
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; docker build $PROJECT_NAME"

