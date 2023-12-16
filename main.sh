#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: The main program that sets up the development environment.

WORKSPACE_DIR=$(dirname "$(readlink -f "$0")")
DATA_DIR=$WORKSPACE_DIR/setup
DOWNLOAD_DIR=$WORKSPACE_DIR/download
SOURCE_DIR=$WORKSPACE_DIR/src

IMAGE_NAME=basic
IMAGE_TAG=v1.0.0

cat <<EOF
Operational Guidelines
  0  [generate image]
  1  [new raw container]
  2  [new go-kratos container]
  3  [new ts-react container]
  4  [new py-conda container]
  5  [new cpp container]
  6  [new xubuntu container] -- Todo
  10 [new mysql server]
  11 [new nacos server] -- Todo
EOF
read -p "Select the operation to be performed: " opt

if [ -z "$opt" ]; then
  echo "Invalid input"
  exit 1
fi

case $opt in
0)
  bash $DATA_DIR/buildimage.sh $IMAGE_NAME $IMAGE_TAG
;;
1)
  bash $DATA_DIR/newraw.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR
;;
2)
  bash $DATA_DIR/newgo.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR $WORKSPACE_DIR
;;
3)
  bash $DATA_DIR/newnode.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR $WORKSPACE_DIR
;;
4)
  bash $DATA_DIR/newpy.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR $WORKSPACE_DIR
;;
5)
  bash $DATA_DIR/newcpp.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR $WORKSPACE_DIR
;;
# 6)
#   bash $DATA_DIR/newxubuntu.sh $IMAGE_NAME $IMAGE_TAG $SOURCE_DIR $DOWNLOAD_DIR $WORKSPACE_DIR
# ;;
10)
  bash $DATA_DIR/newmysql.sh $SOURCE_DIR
;;
*)
  echo "Invalid input"
  exit 1
;;
esac


# Cleaning up images with tag=none.
create_images_opts=(0 10)
for num in "${create_images_opts[@]}"
do
  if [ "$num" -eq $opt ]; then
    bash $DATA_DIR/cleaninvalidimage.sh
  fi
done
