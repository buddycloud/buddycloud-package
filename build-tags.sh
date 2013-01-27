#!/bin/bash 
# Global building script for buddycloud projects
# Checks out all tags from github that were not built yet
# and builds them. All projects must be declared in the 
# projects folder. 

# TODO

CURRENT_DIR=`pwd`
PROJECTS_DIR=$CURRENT_DIR/projects
BUILD_DIR=$CURRENT_DIR/build

for PROJECT_FILE in $PROJECTS_DIR/*; do
  
  echo "Processing project $PROJECT_FILE"
  source $PROJECT_FILE
  
  # Setting project properties
  PROJECT_PATH=$BUILD_DIR/$PROJECT_NAME
  mkdir -p $PROJECT_PATH
  GIT_PATH=$PROJECT_PATH/git
  
  # Updating git folder
  if [ -d "$GIT_PATH" ]; then
    cd $GIT_PATH
    git pull
  else
    git clone $GIT_URL $GIT_PATH
  fi
  
  # Checking not built tags
  cd $GIT_PATH
  for TAG_NAME in `git tag`; do
    TAG_PATH=$PROJECT_PATH/$TAG_NAME
    if [ -d "$TAG_PATH" ]; then
      continue
    else
      mkdir -p $TAG_PATH
      git checkout $TAG_NAME
      
      # Building debian package
      echo 'y' | debuild -S -sa
      
      # Move debian files from parent
      cd $PROJECT_PATH
      mv *.changes *.build *.deb *.dsc *.tar.gz $TAG_PATH
    fi
  done
    
done
