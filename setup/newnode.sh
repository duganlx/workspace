#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Creating a ts-react container

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


# TS-React development environment configuration
echo -e "Available Node.js versions:\n  0 [v16.20.2]\n  1 [v18.9.1]"
read -p "Version selection: " nodeopt
nodearr=""
nodezip=""
nodeunzip=""
case $nodeopt in
0)
  nodearr="https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-x64.tar.gz"
  nodezip="node-v16.20.2-linux-x64.tar.gz"
  nodeunzip="node-v16.20.2-linux-x64"
;;
1) 
  nodearr="https://nodejs.org/dist/v18.9.1/node-v18.9.1-linux-x64.tar.gz"
  nodezip="node-v18.9.1-linux-x64.tar.gz"
  nodeunzip="node-v18.9.1-linux-x64"
;;
*)
  echo "输入无效"
  exit 2
;;
esac


mkdir -p $DOWNLOAD_DIR
if [ ! -e "$DOWNLOAD_DIR/$nodezip" ]; then
  wget -P "$DOWNLOAD_DIR" $nodearr
fi


# Configuration Inside the Container
docker exec -it $container_name /bin/bash -c "tar -C /usr/local -zxf /download/$nodezip"
# Not recommended to use symbolic links, as subsequent npm globally installed commands will still require a symlink (ln -s src dist).
docker exec -it $container_name /bin/bash -c "echo 'export PATH=\$PATH:/usr/local/$nodeunzip/bin' >> /root/.bashrc"
docker exec -it $container_name /bin/bash -c "export PATH=\$PATH:/usr/local/$nodeunzip/bin && npm install -g yarn"


echo -e "Container '$container_name' created successfully. Enter the container with the following command: docker exec -it $container_name /bin/bash"
