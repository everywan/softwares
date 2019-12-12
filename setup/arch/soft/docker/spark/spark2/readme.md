# spark2.2 docker

1. 首先, 下载 spark2.2.0 源码: `wget -c https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz -O spark-2.2.0.tgz`
2. 下载 centos 镜像: `docker pull centos`. 本处用的centos8, 不同版本包名可能不同
3. 构建镜像 `docker build -t wzs/spark2.2 .`
4. 启动容器 `docker-compose up`

任务提交流程
1. 将源码复制到 `/data/temp/spark2.2` 目录下
2. 登录服务器 `ssh root@localhost -p 2201`, 密码也是 root
3. 提交任务: `spark-submit --py-files dependencies.zip run.py`

如果要使用本项目的 hive 镜像, 请先启动 hive 镜像, 再启动本镜像.
- 原因: hive 和 spark 需要网络互通, 需要将 spark 的网络添加到 hive 网络中去.
