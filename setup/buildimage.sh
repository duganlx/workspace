#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Generate image

IMAGE_NAME=$1
IMAGE_TAG=$2

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

container_ids=$(docker ps -q --filter ancestor="$IMAGE_NAME:$IMAGE_TAG")
if [ -n "$container_ids" ]; then
  echo -e "The following containers were created using the image $IMAGE_NAME:$IMAGE_TAG:\n$container_ids"
  read -p "After pressing Enter, deletion will commence..."
  for id in $container_ids; do
    docker rm -f $id
  done
fi

docker build -t $IMAGE_NAME:$IMAGE_TAG -f $SCRIPT_DIR/Dockerfile .