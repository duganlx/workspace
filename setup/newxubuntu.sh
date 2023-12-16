#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Creating a golang container

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


chromedeb=google-chrome-stable_current_amd64.deb
mkdir -p $DOWNLOAD_DIR
if [ ! -e "$DOWNLOAD_DIR/$chromedeb" ]; then
  wget -P "$DOWNLOAD_DIR" https://dl.google.com/linux/direct/$chromedeb
fi


# xubuntu configuration
inrunsh=xubuntu_inrun.sh
cat <<EOT > "$DOWNLOAD_DIR/$inrunsh"
#!/bin/bash

# Set the password for the root user.
echo root:root | chpasswd


apt-get update
apt-get install -y autoconf automake libtool curl make g++ 
apt-get install -y libxcb-icccm4 libxkbcommon-x11-0 fonts-wqy-zenhei fonts-wqy-microhei

apt-get install -y openssh-server
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

apt-get install -y /download/$chromedeb


# Remote Desktop Control
echo -e "About to start configuring 'Remote Desktop Control,' there will be two interactions. Recommended options are as follows:\n" 
echo -e "\tCountry of origin for the keyboard: 19"
echo -e "\tKeyboard layout: 1\n"
read -p "Press Enter to begin..."

apt-get install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils xrdp
adduser xrdp ssl-cert
service xrdp start
echo "exec startxfce4" >> /etc/xrdp/xrdp.ini
service xrdp restart


# Chinese input method
echo -e "About to start configuring 'Chinese Input Method,' there will be two interactions. Recommended options are as follows:\n" 
echo -e "\tConfiguring locales: Select all options starting with zh_CN, i.e., 489, 490, 491, 492."
echo -e "\ta default locale: Select zh_CN, i.e., option 3.\n"
read -p "Press Enter to begin..."
apt-get -y install locales xfonts-intl-chinese fonts-wqy-microhei


# Configure 'Google Chrome.'
cat << EOF

配置"google chrome"

步骤（需要在远程桌面连接后进行）：

1. 右键点击默认浏览器(下方), 点击 "Properties", 会弹出Launcher
2. 点击 "Add New Item", 选中 Google Chrome
3. 右键点击该创建的item, 点击 "Edit Item", 修改其中 Command 内容, 如下

    /usr/bin/google-chrome-stable --disable-dev-shm-usage %U

EOF

EOT


# Configuration Inside the Container
docker exec -it $container_name /bin/bash -c "chmod 750 /download/$inrunsh"
docker exec -it $container_name /bin/bash -c "bash /download/$inrunsh"