#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Creating a golang container

IMAGE_NAME=$1
IMAGE_TAG=$2
SOURCE_DIR=$3
DOWNLOAD_DIR=$4
ROOT_DIR=$5

read -p "Please enter the container name: " container_name
if docker ps -a --format '{{.Names}}' | grep -q $container_name; then
  read -p "The container '$container_name' already exists. Press Enter to proceed with deletion..."
  docker rm -f $container_name
fi


read -p "Please enter the port mapping configuration for container $container_name (separated by spaces): " ports_map
port_map_array=($ports_map)

docker_run_cmd="docker run -itd --name $container_name --privileged=true"
for port_map in ${port_map_array[@]}; do
  docker_run_cmd="$docker_run_cmd -p $port_map"
done


# Choose the mount location for /workspace
container_wsdir=$SOURCE_DIR/$container_name
read -p "Is the container's working directory (/workspace) mounted at the default location? ($container_wsdir), Please enter (y/n): " mountwsopt
case $mountwsopt in
y)
  mkdir -p $container_wsdir
  docker_run_cmd="$docker_run_cmd -v $container_wsdir:/workspace"
;;
n)
  read -p "Please enter the mount location: $ROOT_DIR/" mountwspath
  docker_run_cmd="$docker_run_cmd -v $ROOT_DIR/$mountwspath:/workspace"
;;
*)
  echo "Invalid input"
  exit 1
;;
esac


docker_run_cmd="$docker_run_cmd -v $DOWNLOAD_DIR:/download"
docker_run_cmd="$docker_run_cmd -v /root/.ssh:/root/.ssh"
docker_run_cmd="$docker_run_cmd $IMAGE_NAME:$IMAGE_TAG /bin/bash"


echo -e "The command to be executed is as follows:\n\n\t$docker_run_cmd\n"
read -p "Press Enter to execute the command and create the container..."
$docker_run_cmd


condash="Miniconda3-latest-Linux-x86_64.sh"
mkdir -p $DOWNLOAD_DIR
if [ ! -e "$DOWNLOAD_DIR/$condash" ]; then
  wget -P "$DOWNLOAD_DIR" "https://repo.anaconda.com/miniconda/$condash"
fi

# Configuration Inside the Container
docker exec -it $container_name /bin/bash -c "chmod 750 /download/$condash"
docker exec -it $container_name /bin/bash -c "bash /download/$condash -b -p /usr/local/miniconda"
docker exec -it $container_name /bin/bash -c "echo 'export PATH=\$PATH:/usr/local/miniconda/bin' >> /root/.bashrc"
docker exec -it $container_name /bin/bash -c "pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple"
docker exec -it $container_name /bin/bash -c "apt-get update && apt-get install -y gcc"
docker exec -it $container_name /bin/bash -c "export PATH=\$PATH:/usr/local/miniconda/bin && conda init"

echo -e "Container '$container_name' created successfully. Enter the container with the following command: docker exec -it $container_name /bin/bash"
