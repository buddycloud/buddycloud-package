#!/bin/bash
RESOURCE_FOLDER=$1
PROJECT_FOLDER=$2

for RESOURCE_FILE in $RESOURCE_FOLDER/*rc.sh; do 
  source $RESOURCE_FILE 
done

for TPL_FILE in $PROJECT_FOLDER/*.tpl; do
  CONF_FILE="${TPL_FILE%.*}"
  cp $TPL_FILE $CONF_FILE
  env | cut -d'=' -f1 | while read KEY; do
    VALUE=${!KEY}
    KEY="#$KEY#"
    sed -i "s|$KEY|$VALUE|g" $CONF_FILE 2&>1 > /dev/null
  done
done
