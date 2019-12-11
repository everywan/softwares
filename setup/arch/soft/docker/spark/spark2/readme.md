# spark2.2 docker

1. 首先, 下载 spark2.2.0 源码: `wget -c https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz -O spark-2.2.0.tgz`
2. 下载 centos 镜像: `docker pull centos`. 本处用的centos8, 不同版本包名可能不同
3. 构建镜像 `docker build -t wzs/spark2.2 .`

