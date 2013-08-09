#!/bin/bash 
set -e

# Global nightly building script for buddycloud projects
# Iterates over all the project in the projects folder, 
# checks if there is new commit for it github that was not built yet
# and builds it. 

# Build variables
DEBFULLNAME="Abmar Barros (buddycloud Packaging)"
DEBEMAIL="abmar@buddycloud.com"

DIR_NAME="$(dirname $0)"
CURRENT_DIR="$(cd $DIR_NAME; pwd)"
PROJECTS_DIR=$CURRENT_DIR/projects
BUILD_DIR=$CURRENT_DIR/build

DATE=$(date +%Y%m%d)
DATE_REPR=$(date -R)

DOWNLOAD_ROOT=/var/web/downloads.buddycloud.com/packages/debian/nightly

function process {

  PROJECT_FOLDER=$1

  echo "Processing project $PROJECT_FOLDER"
  source $PROJECT_FOLDER/configure
  
  # Setting project properties
  PROJECT_PATH=$BUILD_DIR/$PROJECT_NAME
  mkdir -p $PROJECT_PATH
  GIT_PATH=$PROJECT_PATH/git
  
  # Updating git folder
  if [ -d "$GIT_PATH" ]; then
    cd $GIT_PATH
    git clean -xdf
    git reset --hard
    git pull
  else
    git clone $GIT_URL $GIT_PATH
  fi
  
  cd $GIT_PATH
  REV="$(git log -1 --pretty=format:%h)"
  
  if [ ! -f ../prev.rev ]; then
    git log --max-parents=0 HEAD --pretty=format:%h > ../prev.rev
  fi
  
  REV_PREV="$(cat ../prev.rev)"
  
  DEB_CREATED=$(ls ../$PROJECT_NAME*.git.$REV*.deb || true)
  if [ -z "$DEB_CREATED" ]; then
    echo "Last build failed, building again."
    rm -rf ../$PROJECT_NAME*.git.$REV* || true 
    OPT_FORCE=true
  else
    unset OPT_FORCE
  fi
  
  if [ "$REV" == "$REV_PREV" ]; then
    if [ -z "$OPT_FORCE" ]; then
      echo "Last build successful. No need to build!"
      return
    fi
    CHANGELOG="  * : No changes"
  else
    # convert svn changelog into deb changelog.
    # strip duplicate blank lines too
    CHANGELOG="$(git log $REV_PREV..$REV --pretty=format:'[ %an ]%n>%s' | ../../../gitcl2deb.sh)"
  fi
  
  BUILD_VERSION="${DIST_VERSION}+dev${DATE}.git.${REV}"
  DIST_REVISION="${BUILD_VERSION}-1"
  
  SOURCE="${PACKAGE}-${BUILD_VERSION}"
  ORIG_TGZ="${PACKAGE}_${BUILD_VERSION}.orig.tar.gz"
  echo "Building orig.tar.gz ..."
  git archive --format=tar "--prefix=${SOURCE}/" "${REV}" | gzip >"../${ORIG_TGZ}"
  
  echo -e "${PACKAGE} (${DIST_REVISION}) ${DIST}; urgency=low\n\n\
${CHANGELOG}\n\n\
 -- ${DEBFULLNAME} <${DEBEMAIL}>  ${DATE_REPR}\n"\
  > $PROJECT_FOLDER/debian/changelog
  
  if [ -f $PROJECT_PATH/changelog.rev ]; then
    cat $PROJECT_PATH/changelog.rev >>$PROJECT_FOLDER/debian/changelog
  fi
  
  cd $PROJECT_PATH
  tar xzf $ORIG_TGZ
  cd $SOURCE
  rsync -a $PROJECT_FOLDER/debian .
  
  # Building debian package
  if [ "${BUILD_ARCH}" == "all" ]; then
    LOGFILE=$PROJECT_PATH/${PACKAGE}_${BUILD_VERSION}_${BUILD_ARCH}.log
    debuild | tee $LOGFILE
  else
    IFS=',' read -ra ARCHS <<< "${BUILD_ARCH}"
    for ARCH in "${ARCHS[@]}"; do
      LOGFILE=$PROJECT_PATH/${PACKAGE}_${BUILD_VERSION}_${ARCH}.log
      debuild -a${ARCH} | tee $LOGFILE || true 
    done
  fi 
    
  # Save previous build info
  echo "$REV" > $PROJECT_PATH/prev.rev
  cp $PROJECT_FOLDER/debian/changelog $PROJECT_PATH/changelog.rev
  
  # Copy packages to download folder
  DOWNLOAD_PACKAGE_DIR=$DOWNLOAD_ROOT/$PACKAGE/$SOURCE
  mkdir -p $DOWNLOAD_PACKAGE_DIR
  rsync -a $PROJECT_PATH/${PACKAGE}_${BUILD_VERSION}* $DOWNLOAD_PACKAGE_DIR --exclude=*.build
}

if [ $# -ne 0 ]; then
  process $1
  exit
fi

for PROJECT_FOLDER_PATH in $PROJECTS_DIR/*; do
  process $PROJECT_FOLDER_PATH
done
