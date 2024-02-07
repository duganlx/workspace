# DevOps Use

记录一些常用操作，方便快速处理问题

## Linux Ops

### vim

- 移动光标到开头`0`, 末尾`$`
- 移动光标到最后一行`G`, 第一行`gg`
- 移动到 20 行 `:20`; 显示行号 `:set nu`; 隐藏行号 `:set nonu`
- 搜索匹配 xxx: `/xxx`, 跳下一个`n`, 跳上一个`N`
- 替换全局 a 成 b: `:%s/a/b/g`
- 删除光标所在字母 `x`
- 剪切光标起始向下 3 行: `3 dd`
- 剪切光标到行末尾 `d$`; 行首到光标 `d0`;
- 输入模式进入方式: 光标左 `i`; 光标行首 `I`; 光标右 `a`; 光标行末 `A`; 光标下添行 `o`; 光标上添行 `O`;
- 粘贴 `p`
- 撤销 `u`

### positioning

- 匹配字符 xxx 后 5 行的内容 `.. | grep -A 5 xxx`
- 匹配字符 xxx 前 5 行的内容 `.. | grep -B 5 xxx`
- 最后 10 行 `tail -n 10 info.log`
- 开头 10 行 `head -n 10 info.log`
- 实时监控文件 `tail -f info.log`

### docker

- 查看文件挂载 `docker inspect --format '{{ json .Mounts }}' xxx`
- 查看端口映射 `docker port xxx`
- 查看 2024-02-02 后的最新 10 条日志 `docker logs --since="2024-02-02" --tail=10 xxx`; 实时加 `-f`; 30 分钟内 `--since 30m`;
- 拷贝文件 `docker cp /root/a xxx:/root/b`
- 进入容器 `docker exec -it xxx /bin/bash`
- 编译 Dockerfile `docker build -t xxx:v1.1 .`

### resource monitor

- 资源使用情况 `top`
- 进程情况 `ps aux`
- cpu 情况 `mpstat`
- 内存情况 `free -h`; 实时 `watch -n 1 free -m`
- 硬盘情况 `df -h`; 文件夹大小 `du -h /path`;

### git

- 查看仓库状态 `git status`
- 压缩提交: a. `git rebase -i xxx`; b. 将要压缩的提交的 pick 改为 s; c. 写提交注释

## jhl

### 资源

- [jfrog](https://jfrog.jhlfund.com/ui/packages)

### golang

私仓配置

```bash
# 配置go mod 私有仓库
go env -w GOPRIVATE=gitlab.jhlfund.com
# 配置不使用代理
go env -w GONOPROXY=gitlab.jhlfund.com
# 配置不验证包(无用)
go env -w GONOSUBDB=gitlab.jhlfund.com
# 配置不加密访问
go env -w GOINSECURE=gitlab.jhlfund.com
```

go 依赖包保存位置

- `/root/.cache/go-build`
- `/root/gowork/pkg/mod ---> GOPATH/pkg/mod`

## dev

### 环境

vscode: `Docker`; `Remote - Container`; `Prettier - Code formatter`;

wins: `wsl2`; `Windows Terminal`

### 前端

文档

- [matter.js](https://brm.io/matter-js/docs/)
