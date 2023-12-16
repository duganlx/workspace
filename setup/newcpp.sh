#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Creating a raw container

IMAGE_NAME=$1
IMAGE_TAG=$2
SOURCE_DIR=$3
DOWNLOAD_DIR=$4

read -p "Please enter the container name: " container_name
if docker ps -a --format '{{.Names}}' | grep -q $container_name; then
  read -p "The container '$container_name' already exists. Press Enter to proceed with deletion..."
  docker rm -f $container_name
fi

container_wsdir=$SOURCE_DIR/$container_name
mkdir -p $container_wsdir


docker_run_cmd="docker run -itd --name $container_name --privileged=true"
docker_run_cmd="$docker_run_cmd -v $container_wsdir:/workspace"

docker_run_cmd="$docker_run_cmd -v $DOWNLOAD_DIR:/download"
docker_run_cmd="$docker_run_cmd -v /root/.ssh:/root/.ssh"
docker_run_cmd="$docker_run_cmd $IMAGE_NAME:$IMAGE_TAG /bin/bash"


echo -e "The command to be executed is as follows:\n\n\t$docker_run_cmd\n"
read -p "Press Enter to execute the command and create the container..."
$docker_run_cmd

docker exec -it $container_name /bin/bash -c "apt-get update && apt-get install -y build-essential man gcc-doc gdb libreadline-dev libsdl2-dev llvm tmux"

echo -e "Container '$container_name' created successfully. Enter the container with the following command: docker exec -it $container_name /bin/bash"
