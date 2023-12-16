#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Creating a golang container

SOURCE_DIR=$1
version="8.0.20"

if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "mysql:$version"; then
  docker pull mysql:$version
fi


read -p "Please enter the container name: " container_name
if docker ps -a --format '{{.Names}}' | grep -q $container_name; then
  read -p "The container '$container_name' already exists. Press Enter to proceed with deletion..."
  docker rm -f $container_name
fi

if [ -z "$container_name" ]; then
    echo "The container name cannot be an empty string."
    exit 2
fi

container_wsdir=$SOURCE_DIR/$container_name
mkdir -p $container_wsdir


# Copy configuration files
read -p "Would you like to recopy the configuration files? , Please enter (y/n): " initmountopt
case $initmountopt in
y)
  docker run -d --name $container_name -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root mysql:$version
  rm -rf $container_wsdir/*
  docker cp $container_name:/etc/mysql $container_wsdir/etc
  docker rm -f $container_name
;;
n)
  echo "Skip copying configuration files."
;;
*)
  echo "Invalid input"
  exit 2
;;
esac

docker run -d --name $container_name \
  -p 3306:3306 \
  -v $container_wsdir/etc:/etc/mysql \
  -v $container_wsdir/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:$version


echo -e "Container $container_name created successfully. Additional configuration is required:"
echo -e "\n\tdocker exec -it mydb /bin/bash"
echo -e "\tmysql -u root -p <enter> root"
echo -e "\tALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';\n"
echo -e "\nIf you encounter the issue 'Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2),' please restart the container.\n"