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
DOCKER_PROJECT_HOST=$CURRENT_DIR/projects/$PROJECT_NAME/docker
bash $CURRENT_DIR/replace-vars.sh $CONF_FOLDER $DOCKER_PROJECT_HOST
for TPL_FILE in $DOCKER_PROJECT_HOST/*.tpl; do
  CONF_FILE="${TPL_FILE%.*}"
  CONF_FILE_NAME="$(basename $CONF_FILE)"
  scp $CONF_FILE $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$CONF_FILE_NAME
done

# Copy latest DEB file
if $STAGE_DEB; then
  LATEST_DEB=$(ls -t *.deb | head -n 1)
  scp $LATEST_DEB $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$PROJECT_NAME.deb
fi

# Build docker
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; docker build --no-cache -t $PROJECT_NAME ."
scp $CURRENT_DIR/docker.conf $DEPLOY_USER_AT_HOST:/etc/init/$PROJECT_NAME.conf
PROJECT_NAME_KEY="#PROJECT_NAME#"
ssh $DEPLOY_USER_AT_HOST  "sed -i \"s|$PROJECT_NAME_KEY|$PROJECT_NAME|g\" /etc/init/$PROJECT_NAME.conf"
