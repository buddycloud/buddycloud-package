#!/bin/bash

PROJECT_NAME=$1
CURRENT_DIR="$(cd $DIR_NAME; pwd)"

# Source config
source "$CURRENT_DIR/settings.production"

# Docker folder
DOCKER_PROJECT=$PACKAGE_PROJECT/projects/$PROJECT_NAME/docker

# Run
DEPLOY_USER_AT_HOST=$DEPLOY_DOCKER_USER@$DEPLOY_DOCKER_HOST
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; ./run_docker $PROJECT_NAME"
