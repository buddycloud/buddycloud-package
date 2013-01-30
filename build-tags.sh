#!/bin/bash 

# Global building script for buddycloud projects
# Checks out all tags from github that were not built yet
# and builds them. All projects must be declared in the 
# projects folder. 

# Build variables
DEBFULLNAME="Abmar Barros (buddycloud Packaging)"
DEBEMAIL="abmar@buddycloud.com"

DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"
PROJECTS_DIR=$CURRENT_DIR/projects
BUILD_DIR=$CURRENT_DIR/tags

DATE=$(date +%Y%m%d)
DATE_REPR=$(date -R)

DOWNLOAD_ROOT=/var/web/downloads.buddycloud.com/packages/debian/releases

for PROJECT_FOLDER in $PROJECTS_DIR/*; do
  
  echo "Processing project $PROJECT_FOLDER"
  source $PROJECT_FOLDER/configure
  
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
  
  git checkout master
  
  cd $GIT_PATH
  TAG_PREV="$(git log --max-parents=0 HEAD --pretty=format:%h)"
  
  rm -f $PROJECT_PATH/changelog
  
  # Checking not built tags
  for TAG in $(git tag); do

    cd $GIT_PATH
  
    BUILD_VERSION="$(echo ${TAG} | cut -b 1 --complement)"
    DIST_REVISION="${BUILD_VERSION}-1"
    
    CHANGELOG="$(git log $TAG_PREV..$TAG --pretty=format:'[ %an ]%n>%s' | ../../../gitcl2deb.sh)"
    echo -e "${PACKAGE} (${DIST_REVISION}) ${DIST}; urgency=low\n\n\
${CHANGELOG}\n\n\
 -- ${DEBFULLNAME} <${DEBEMAIL}>  ${DATE_REPR}\n"\
    > $PROJECT_PATH/changelog.tmp
    
    if [ -f "$PROJECT_PATH/changelog" ]; then
      cat $PROJECT_PATH/changelog >> $PROJECT_PATH/changelog.tmp
    fi
    
    mv $PROJECT_PATH/changelog.tmp $PROJECT_PATH/changelog
    
    SOURCE="${PACKAGE}-${BUILD_VERSION}"

    TAG_PREV=${TAG}
    
    if [ -d "${PROJECT_PATH}/${SOURCE}" ]; then
      continue
    else
      ORIG_TGZ="${PACKAGE}_${BUILD_VERSION}.orig.tar.gz"
      
      git archive --format=tar "--prefix=${SOURCE}/" "${TAG}" | gzip > "$PROJECT_PATH/${ORIG_TGZ}"
      
      cd $PROJECT_PATH
      tar xzf $ORIG_TGZ
      cd $SOURCE
      
      rsync -a $PROJECT_FOLDER/debian .
      cp $PROJECT_PATH/changelog debian/changelog
      
      # Building debian package
      if [ "${BUILD_ARCH}" == "all" ]; then
        debuild
      else
        IFS=',' read -ra ARCHS <<< "${BUILD_ARCH}"
        for ARCH in "${ARCHS[@]}"; do
          debuild -a${ARCH} || true
        done
      fi
      
      # Copy packages to download folder
      DOWNLOAD_PACKAGE_DIR=$DOWNLOAD_ROOT/$PACKAGE/$SOURCE
      mkdir -p $DOWNLOAD_PACKAGE_DIR
      rsync -a $PROJECT_PATH/${PACKAGE}_${BUILD_VERSION}* $DOWNLOAD_PACKAGE_DIR
      
    fi  
  done
    
done
