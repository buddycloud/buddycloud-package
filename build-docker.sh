DEPLOY_USER=
DEPLOY_HOST=
PACKAGE_PROJECT=
LATEST_DEB=$(ls -t *.deb | head -n 1)
DEPLOY_USER_AT_HOST=$DEPLOY_USER@$DEPLOY_HOST

# Get latest changes for buddycloud-package
ssh $DEPLOY_USER_AT_HOST "cd $PACKAGE_PROJECT; git pull"

# Docker bits folder
DOCKER_PROJECT=$PACKAGE_PROJECT/projects/$1/docker

scp $LATEST_DEB $DEPLOY_USER_AT_HOST:$DOCKER_PROJECT/$1.deb
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; docker build ."
ssh $DEPLOY_USER_AT_HOST "cd $DOCKER_PROJECT; ./run_docker $1"
