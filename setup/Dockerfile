FROM ubuntu:jammy-20230308
LABEL author=lvx email=840797783@qq.com

SHELL ["/bin/bash", "-c"]

# Configuration: Switching to Tsinghua Mirror for package resources.
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo '# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释' > /etc/apt/sources.list
RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '' >> /etc/apt/sources.list
RUN echo 'deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '' >> /etc/apt/sources.list
RUN echo '# 预发布软件源，不建议启用' >> /etc/apt/sources.list
RUN echo '# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo '# # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse' >> /etc/apt/sources.list

# Installation: Commonly Used Tools
RUN apt-get update && apt-get install -y vim net-tools iputils-ping wget git unzip telnet

# Solution: Resolving the issue of requiring two delete operations in the terminal to delete Chinese characters.
ENV LANG=C.UTF-8

# Solution: Resolving the issue of the terminal not allowing input in Chinese.
RUN cd /root && touch .inputrc
RUN echo 'set meta-flag on' >> /root/.inputrc
RUN echo 'set convert-meta off' >> /root/.inputrc
RUN echo 'set input-meta on' >> /root/.inputrc
RUN echo 'set output-meta on' >> /root/.inputrc

# Solution: Resolving the issue of not being able to input Chinese characters in Vim.
RUN cd /root && touch .vimrc
RUN echo 'set fileencodings=utf-8,cp936,gb2312,gbk,gb18030' >> /root/.vimrc
RUN echo 'set termencoding=utf-8' >> /root/.vimrc
RUN echo 'set fileformats=unix' >> /root/.vimrc
RUN echo 'set encoding=prc' >> /root/.vimrc

# 开发配置
RUN mkdir /download /workspace

WORKDIR /workspace