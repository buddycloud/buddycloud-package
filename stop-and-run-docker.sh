#!/bin/bash

set -x

PROJECT_NAME=$1
BUILD_ENV=$2
DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"

# Source config
source "$CURRENT_DIR/settings.$BUILD_ENV"

# Docker folder
DOCKER_PROJECT=$PACKAGE_PROJECT/projects/$PROJECT_NAME/docker

# Run
DEPLOY_USER_AT_HOST=$DEPLOY_DOCKER_USER@$DEPLOY_DOCKER_HOST
ssh $DEPLOY_USER_AT_HOST "docker stop $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "docker kill $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "docker rm $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; ./run_docker $PROJECT_NAME"
