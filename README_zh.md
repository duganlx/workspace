# Workspace

## Setup

开发最让人头痛的就是环境的搭建，为了解决这个问题，本项目采用 wsl + docker 的方式迅速搭建在 wins 下的各种开发环境，目前已经支持 go-kratos、ts-react、python、cpp 四种开发环境，以及构建 mysql 服务。

_前提条件_

你的操作系统是 Windows x64，并且安装了 [wsl2](https://learn.microsoft.com/zh-cn/windows/wsl/install) 和 [docker desktop](https://www.docker.com/products/docker-desktop/)。

_使用姿势_

在 wsl2 中克隆本项目，进入项目后输入 `bash main.sh`，按照操作指引输入即可，操作指引如下所示。需要说明的是在执行指令 `1,2,3,4,5` 之前，需要先执行 `0`。

```
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
Select the operation to be performed:
```

_说明_

基础镜像是 ubuntu22.04，并在此基础上做了如下配置，以适合中国开发者

- apt 镜像源为清华镜像源 https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
- 处理中文输入乱码问题
- 下载常用的开发工具
- 安全性考虑，将开发的文件全部采用挂载式

