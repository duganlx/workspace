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


# Golang-Kratos development environment configuration
echo -e "Available Go versions:\n  0 [go18]\n  1 [go19]\n  2 [go20]"
read -p "Version selection: " goopt
gozip=""
case $goopt in
0)
  gozip="go1.18.10.linux-amd64.tar.gz"
;;
1)
  gozip="go1.19.13.linux-amd64.tar.gz"
;;
2) 
  gozip="go1.20.11.linux-amd64.tar.gz"
;;
*)
  echo "输入无效"
  exit 2
;;
esac


mkdir -p $DOWNLOAD_DIR
if [ ! -e "$DOWNLOAD_DIR/$gozip" ]; then
  wget -P "$DOWNLOAD_DIR" https://golang.google.cn/dl/$gozip
fi
if [ ! -e "$DOWNLOAD_DIR/protoc-22.2-linux-x86_64.zip" ]; then 
  wget -P "$DOWNLOAD_DIR" https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip
fi

inrunsh=newgo_inrun.sh
cat <<EOT > "$DOWNLOAD_DIR/$inrunsh"
#!/bin/bash

tar -C /usr/local -zxf /download/$gozip
mkdir -p /root/go/bin /root/go/pkg

# Environment Variable Configuration
echo 'export PATH=\$PATH:/usr/local/go/bin' >> /root/.bashrc
echo 'export GOBIN=/root/go/bin' >> /root/.bashrc
echo 'export GOPROXY=https://goproxy.cn,direct' >> /root/.bashrc
echo 'export GOSUMDB=sum.golang.google.cn' >> /root/.bashrc
echo 'export PATH=\$PATH:\$GOBIN' >> /root/.bashrc

export PATH=\$PATH:/usr/local/go/bin
export GOBIN=/root/go/bin
export GOPROXY=https://goproxy.cn,direct
export PATH=\$PATH:\$GOBIN


unzip -d /download/tmp /download/protoc-22.2-linux-x86_64.zip
mv /download/tmp/bin/protoc /root/go/bin
rm -rf /download/tmp


# Installation: Dependencies for Kratos
go install github.com/go-kratos/kratos/cmd/kratos/v2@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
go install github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2@latest
go install github.com/google/gnostic/cmd/protoc-gen-openapi@latest
go install github.com/google/wire/cmd/wire@latest
go install github.com/envoyproxy/protoc-gen-validate@latest

# Configuration: gitlab.jhlfund.com
go env -w GOPRIVATE=gitlab.jhlfund.com
go env -w GONOPROXY=gitlab.jhlfund.com
# go env -w GONOSUBDB=gitlab.jhlfund.com
go env -w GOINSECURE=gitlab.jhlfund.com
EOT


# Configuration Inside the Container
docker exec -it $container_name /bin/bash -c "chmod 750 /download/$inrunsh"
docker exec -it $container_name /bin/bash -c "bash /download/$inrunsh"
docker exec -it $container_name /bin/bash -c 'apt-get update && apt-get install -y gcc automake autoconf libtool make pkg-config libzmq5 libczmq-dev g++'


echo -e "Container '$container_name' created successfully. Enter the container with the following command: docker exec -it $container_name /bin/bash"
