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
ssh $DEPLOY_USER_AT_HOST "service $PROJECT_NAME stop | true"
ssh $DEPLOY_USER_AT_HOST "docker stop $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "docker kill $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "docker rm $PROJECT_NAME | true"
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; ./run_docker $PROJECT_NAME"

sleep $WAIT_RUN_TIME

# Check if it is running
ssh $DEPLOY_USER_AT_HOST "docker ps | grep $PROJECT_NAME:latest"
RUN_CHECK=$?

if [ $RUN_CHECK == 1 ]; then
  CONTAINER=$(ssh $DEPLOY_USER_AT_HOST "docker ps -a | grep $PROJECT_NAME:latest | head -n1 | cut -d' ' -f1")
  if [ ! -z "$CONTAINER" ]; then
    ssh $DEPLOY_USER_AT_HOST "docker logs $CONTAINER"
  fi
  exit 1
fi

ssh $DEPLOY_USER_AT_HOST "service $PROJECT_NAME start | true"
