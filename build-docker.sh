#!/bin/bash
set -x

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

# Replace variables
bash $CURRENT_DIR/replace-vars.sh $CONF_FOLDER $DOCKER_PROJECT
for TPL_FILE in $DOCKER_PROJECT/*.tpl; do
  CONF_FILE="${TPL_FILE%.*}"
  scp $CONF_FILE $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$CONF_FILE
done

# Copy latest DEB file
if $STAGE_DEB; then
  LATEST_DEB=$(ls -t *.deb | head -n 1)
  scp $LATEST_DEB $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$PROJECT_NAME.deb
fi

# Build docker
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; docker build -t $PROJECT_NAME ."

