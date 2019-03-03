# RUN

run 命令用于创建容器.

## 使用
常用格式如下: `docker run --name "name" -P -p hostPort:dockerport -tid ImageID/Name "cmd"`
- name: 容器名称
- `-p`: 映射外网的端口, 多个 `-p` 表示映射多个端口
- `-t`: 指定Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上
- `-i`: 指定容器的标准输入保持打开
- `-d`: 容器创建后自动在后台运行
- `--rm`: 构建是自动删除已存在的容器
- `cmd`: 挂载点, 默认 `/bin/bash`. 
  - 如果需要在容器内开启sshd服务且宿主机系统是centos7时, 需要将载入点设置为: `/usr/sbin/init`. 否则便会报错: `Failed to get D—Bus connection:NO connection to service manager`(无法获取DBUS 的链接)
  - 原因: [centos7 docker无法使用systemctl](#centos7-docker无法使用systemctl)
        
3. 示例 
    ```Bash
    # 创建镜像 imageID 的容器, 命名为hadoop0, host 为hadoop0, 并映射口50070到外网, 挂载点为 /usr/sbin/init
    docker run --name hadoop0 --hostname hadoop0 -d -P -p 50070:50070 -p 8088:8088 -ti imageID /usr/sbin/init
    # 创建镜像 并且挂载目录/设备
    docker run -it --name NAME -v /home/:/mnt/home --privileged=true --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl myconda:cuda bash
    ```
