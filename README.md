# Workspace

Translations: [English](README.md) | [简体中文](README_zh.md)

## Setup

The most headache-inducing aspect of development is setting up the environment. To address this issue, this project employs the combination of WSL (Windows Subsystem for Linux) and Docker to swiftly establish various development environments on Windows. Currently, it supports four development environments: go-kratos, ts-react, python, and cpp, along with the ability to build MySQL services.

*Prerequisites*

Your operating system is Windows x64, and xx [wsl2](https://learn.microsoft.com/zh-cn/windows/wsl/install) 和 [docker desktop](https://www.docker.com/products/docker-desktop/) are installed.

*Usage Instructions*

Clone this project in WSL 2, navigate to the project directory, and enter `bash main.sh`. Follow the instructions provided and input the required information. The operation guide is as follows. It's important to note that before executing commands `1, 2, 3, 4, 5`, you should execute command `0`.

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

*Tips*

In the `0  [generate image]` process, the base image is Ubuntu 22.04, and the following configurations have been made to cater to Chinese developers:

- The APT package manager is configured to use Tsinghua mirror source (https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/).
- Chinese input encoding issues have been addressed.
- Common development tools have been downloaded and installed.
- For security considerations, all development files are mounted using a mounted approach.


## Appendix

VSCode Development Configuration

```
Tab Size: 2
Word Wrap: on
```