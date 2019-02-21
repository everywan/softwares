<!-- TOC -->

- [安装&入门](#安装入门)
    - [docker 安装](#docker-安装)
        - [Linux](#linux)
    - [容器操作](#容器操作)
        - [创建容器](#创建容器)
            - [挂载目录/设备](#挂载目录设备)
        - [其他基础操作](#其他基础操作)
        - [扩展命令](#扩展命令)
    - [镜像操作](#镜像操作)
        - [构建镜像](#构建镜像)
    - [引用](#引用)
        - [centos7-docker无法使用systemctl](#centos7-docker无法使用systemctl)
        - [慎用docker-commit](#慎用docker-commit)

<!-- /TOC -->

# 安装&入门
## docker 安装
---
### Linux
- [阿里云镜像仓库地址](https://cr.console.aliyun.com/#/imageSearch)
- 阿里云已经是 docker 在国内的正式代理, 也可以下载 docker 官网镜像, 推荐使用
    ```Bash
    # 安装docker
    curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
    # 加速器
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
        "registry-mirrors": ["https://pfonbmyi.mirror.aliyuncs.com"]
    }
    EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```
- 错误处理: 根据报错内容处理即可
    - deepin 等系统安装会报错, 抛出的错误中有 dkg 包的下载位置, 手动从镜像源上下载, 使用 dpkg命令 安装即可.
        - 原因是 因为 deepin 的内核版本和 ubunutu 不同, 导致找不到相应的软件包(deepin 是基于 ubuntu 开发的)

## 容器操作
> 多参考 man/help 和 [官方文档](https://docs.docker.com/engine/reference/run/#general-form)

---
### 创建容器
1. 命令格式(简洁版): `docker run --name "name" -P -p hostPort:dockerport -tid ImageID/Name "cmd"`
    - name: 容器名称
    - `-p`: 映射外网的端口, 多个 `-p` 表示映射多个端口
    - `-t`: 指定Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上
    - `-i`: 指定容器的标准输入保持打开
    - `-d`: 容器创建后自动在后台运行
    - `cmd`: 挂载点, 默认 `/bin/bash`. 
        - 如果需要在容器内开启sshd服务且宿主机系统是centos7时, 需要将载入点设置为: `/usr/sbin/init`. 否则便会报错: `Failed to get D—Bus connection:NO connection to service manager`(无法获取DBUS 的链接)
        - 原因: [centos7 docker无法使用systemctl](#centos7-docker无法使用systemctl)
2. 命令格式(完整版): [官方文档](https://docs.docker.com/engine/reference/commandline/run)
3. 示例 
    ```Bash
    # 创建镜像 imageID 的容器, 命名为hadoop0, host 为hadoop0, 并映射口50070到外网, 挂载点为 /usr/sbin/init
    docker run --name hadoop0 --hostname hadoop0 -d -P -p 50070:50070 -p 8088:8088 -ti imageID /usr/sbin/init
    # 创建镜像 并且挂载目录/设备
    docker run -it --name NAME -v /home/:/mnt/home --privileged=true --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl myconda:cuda bash
    ```
#### 挂载目录/设备

### 其他基础操作
1. 进入容器: `docker exec -ti "containID/Name" /bin/bash`
    - attach也可以进入容器, 但是exit退出时会stop容器, 所以一般使用exec
    - attach格式: `docker attach containID/Name`
2. 查看容器stdout: `docker logs containID/Name`
3. (停止|开启) 容器: `docker stop | start name/id`
4. 删除容器: `docker rm containID/Name`

### 扩展命令
1. 容器/宿主机复制文件: `docker cp containID/Name:path localpath`
2. 显示更改: `docker diff containID/Name`
3. 根据容器ID获取容器IP地址: `docker inspect --format '{{ .NetworkSettings.IPAddress }}' f777da7b9051`

## 镜像操作
1. 显示列表:    `docker images`
2. 重命名镜像:   `docker tag image "new_rep/tag"`
3. 删除镜像:    `docker rmi imageID/Name`
4. 把 image 存储到本地文件和从本地文件读取
    ````
    docker save -O "file.tar" imageID
    docker load -i "file.tar"
    ````
### 构建镜像
1. Dockerfile: Dockerfile 是一个文本文件, 其内包含了一系列的 **指令(Instruction)**. 每条指令都描述和构建一层镜像层
    ```Bash
    # 构建镜像,Dockerfile 命名必须为 "Dockerfile"
    docker build -t rep/tag Dockerfile_path
    ```
2. 从容器构建: 将容器保存为镜像
    - [慎用docker-commit](#慎用docker-commit)
    ```Bash
    docker commit [options] containID/Name rep/tag
       # - -a:作者
       # - -c:使用dockerfile
       # - -m:说明
       # - -p:commit时, 暂停容器
    ```

## 引用
### centos7-docker无法使用systemctl
- 原因: 在centos7/centos7之后的版本中, 包含systemd命令但是默认没有生效.
- 解决办法
    - [解决办法](https://github.com/docker-library/docs/tree/master/centos#systemd-integration)
    - 启动容器时,设置挂载点为 `/usr/sbin/init`, 类似
        - `docker run --name hadoop --hostname hadoop  -ti 483cc84ba5b2 /usr/sbin/init`
        - 发现的问题: 使用deepin时,并没有`/usr/sbin/init`文件
        
### 慎用docker-commit
使用 `docker commit` 意味着所有对镜像的操作都是黑箱操作, 生成的镜像也被称为**黑箱镜像**, 换句话说, 就是除了制作镜像的人知道执行过什么命令、怎么生成的镜像, 别人根本无从得知. 而且, 即使是这个制作镜像的人, 过一段时间后也无法记清具体在操作的. 虽然 `docker diff` 或许可以告诉得到一些线索, 但是远远不到可以确保生成一致镜像的地步. 这种黑箱镜像的维护工作是非常痛苦的. 

应该尽量使用 dockerfile 构建镜像, 避免使用  `docker commit`.
