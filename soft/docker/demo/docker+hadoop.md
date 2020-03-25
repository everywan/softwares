# 搭建基于docker的Hadoop分布式系统

本文中, 作者使用Dockerfile来构建docker image.   
有机会的话, 我会写一个脚本来完成整个操作而不用一步步来了. 

<!-- TOC -->

- [搭建基于docker的Hadoop分布式系统](#搭建基于docker的hadoop分布式系统)
    - [Dockerfile编写](#dockerfile编写)
    - [构建镜像](#构建镜像)
    - [指定docker容器的IP地址](#指定docker容器的ip地址)
    - [配置hadoop项](#配置hadoop项)
    - [部署分布式Hadoop系统](#部署分布式hadoop系统)
    - [测试](#测试)
    - [遇到的问题](#遇到的问题)
    - [ETC](#etc)

<!-- /TOC -->

## Dockerfile编写
作者默认将Hadoop安装到了 `/usr/local/` 下
````
# 选取一个镜像
FROM docker.io/centos

# 镜像作者  
MAINTAINER wzs

# 安装sshd ssh
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
# 将sshd的UsePAM参数设置成no 
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# 添加测试用户root, 密码root, 并且将此用户添加到sudoers里  
RUN echo "root:root" | chpasswd  
RUN echo "root   ALL=(ALL)       ALL" >> /etc/sudoers

# 启动sshd服务并且暴露22端口  
RUN mkdir /var/run/sshd  
EXPOSE 22  
CMD ["/usr/sbin/sshd", "-D"]

# 安装&配置jdk
ADD jdk-8u131-linux-x64.tar.gz /usr/local/
RUN mv /usr/local/jdk1.8.0_131 /usr/local/jdk1.8
ENV JAVA_HOME /usr/local/jdk1.8
ENV PATH $JAVA_HOME/bin:$PATH

# 安装&配置hadoop
ADD hadoop-2.8.0.tar.gz /usr/local
RUN mv /usr/local/hadoop-2.8.0 /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
````

## 构建镜像
需要注意的是, Dockerfile文件命名必须为Dockerfile.   
注意最后有一个 '.' , 代表Dockerfile的路径. 
````
docker build -t wzs/centos-hadoop .
````

## 指定docker容器的IP地址
指定docker容器IP之后, 可以避免每次容器重启导致的IP更换问题. 
````
# 首先, 创建hadoop0,hadoop1,hadoop2三个节点, 暴露 50070 8088 端口, 使宿主机可以通过浏览器访问容器中hadoop集群的服务: http://localhost:50070/
# entrypoint 必须设置为 /usr/sbin/init, 否则不能使用systemd命令
docker run --name hadoop0 --hostname hadoop0 -d -P -p 50070:50070 -p 8088:8088 -ti 483cc84ba5b2 /usr/sbin/init
docker run --name hadoop1 --hostname hadoop1 -d -P -ti 483cc84ba5b2 /usr/sbin/init
docker run --name hadoop2 --hostname hadoop2 -d -P -ti 483cc84ba5b2 /usr/sbin/init

# 使用pipework设置固定IP
git clone https://github.com/jpetazzo/pipework.git 
cp -rp pipework/pipework /usr/local/bin/

yum -y install bridge-utils

# 创建网络
brctl addbr br0
ip link set dev br0 up
ip addr add 192.168.2.1/24 dev br0

# 给容器设置固定IP, 设置完成后, 能ping通就OK
pipework br0 hadoop0 192.168.2.10/24
pipework br0 hadoop1 192.168.2.11/24
pipework br0 hadoop2 192.168.2.12/24
````

## 配置hadoop项
开始配置Hadoop配置之前, 先做一些必要的前提工作
````
# 进入hadoop0节点
docker exec -ti hadoop0 /bin/bash

# 修改hosts, 三个节点都需要执行. 
# 清除hadoop0中原有的 hadoop映射, 原因稍后讲
echo 192.168.2.10       hadoop0 >> /etc/hosts
echo 192.168.2.11       hadoop1 >> /etc/hosts
echo 192.168.2.12       hadoop2 >> /etc/hosts

# 设置ssh免密码登陆
systemctl start sshd
mkdir /home/.ssh
cd /home/.ssh
ssh-keygen -t rsa
ssh-copy-id -i hadoop0
ssh-copy-id -i hadoop1
ssh-copy-id -i hadoop2
# 可以以 ssh root@hadoop1 测试是否成功
````
然后, 开始配置Hadoop. 
````
vi /usr/local/hadoop/etc/hadoop/hadoop-env.sh
export JAVA_HOME=/usr/local/jdk1.8

vi /usr/local/hadoop/etc/hadoop/core-site.xml
<configuration>
    <property>
            <name>fs.defaultFS</name>
            <value>hdfs://hadoop0:9000</value>
    </property>
    <property>
            <name>hadoop.tmp.dir</name>
            <value>/usr/local/hadoop/tmp</value>
    </property>
        <property>
                <name>fs.trash.interval</name>
                <value>1440</value>
    </property>
</configuration>

# 配置 HDFS 的地址和端口号
vi /usr/local/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.permissions</name>
        <value>false</value>
    </property>
</configuration>

vi /usr/local/hadoop/etc/hadoop/yarn-site.xml
<configuration>
    <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
    </property>
    <property> 
            <name>yarn.log-aggregation-enable</name> 
            <value>true</value> 
    </property>
</configuration>

# 安装 which 工具
yum install -y which
ssh root@hadoop1
yum install -y which
ssh root@hadoop2
yum install -y which

# 格式化HDFS文件系统
/usr/local/hadoop/bin/hdfs namenode -format
# 启动Hadoop
/usr/local/hadoop/sbin/start-all.sh
````
此时, 输入 jps 命令查看部署是否成功. 出现类似以下提示则表示成功了：
````
3267 SecondaryNameNode
3003 NameNode
3664 Jps
3397 ResourceManager
3090 DataNode
3487 NodeManager
````
如果只需要一个Hadoop节点, 那么至此, 我们就已经配置好了. 
## 部署分布式Hadoop系统

> 如果不需要部署分布式的Hadoop系统, 那么此节可以略过.

首先, 停止Hadoop系统, 然后, 配置主节点和子节点
````
/usr/local/hadoop/sbin/stop-all.sh

# add
vi /usr/local/hadoop/etc/hadoop/yarn-site.xml
    <property>
        <description>The hostname of the RM.</description>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop0</value>
  </property>

vi /usr/local/hadoop/etc/hadoop/slaves
hadoop1
hadoop2

# 复制到另外两台机器(确保已经配置好ssh)
scp  -rq /usr/local/hadoop   hadoop1:/usr/local
scp  -rq /usr/local/hadoop   hadoop2:/usr/local
````

## 测试
首先是运行jps命令查看进程, 然后运行测试数据试下
```
cd /usr/local/hadoop

sbin/start-all.sh

vi a.txt
    hello you
    hello me
# 上传到hdfs
hdfs dfs -put a.txt /
# 执行 wordcount 程序
cd /usr/local/hadoop/share/hadoop/mapreduce
hadoop jar hadoop-mapreduce-examples-2.8.0.jar wordcount /a.txt /out

hdfs dfs -text /out/part-r-00000
# 输出以下就说明OK了
    hello 2
    me 1
    you 1
```

## 遇到的问题

如果Hadoop运行时出现问题, 可以访问 [http://localhost:50070/logs/](http://localhost:50070/logs/) 查看日志文件, 排查错误.   

以下是作者遇到的一些问题：
1. 上述网站不可访问: 
    - 必须在Hadoop系统运行时, 此网站才可以访问.
    - 如果hadoop已经运行, 但是还是不可访问, 参考[网络问题排查](/ETC/WebError.md)
1. 以centos7做为宿主机时, 我们创建docker时映射的50070|8088端口在宿主机中是tcp6(即ipv6)格式的. 
    - tcp6端口不能telnet通. 但是, 却是支持ipv4访问. 
    - 作者从搜索到了一个不错的例子, 有兴趣的同学可以看下：[例子](http://www.chengweiyang.cn/2017/03/05/why-netstat-not-showup-tcp4-socket/)
1. 当没有停止容器就重启了宿主机OS时, 会遇到jps命令找不到的情况. 原因是JAVA环境变量失效了. 需要重新配置
    - [JAVA环境变量配置](/OS/Linux/set_env.md)
1. 启动Hadoop之后, datanode节点没有启动: 出现此问题可能有很多种情况. 
    - core-site文件设置中, 作者开放了hadoop0的9000端口, 如果我们刚开始没有清除hadoop0原有的hosts映射, 那么在映射时便会映射到127.0.0.2(hadoop0 IP地址), 导致slave节点连接不上hadoop0的9000端口

## ETC

- 每次重启虚拟机, 需要：重新启动Docker, 重新分配IP, 修改hosts文件. [作者认为的原因](/OS/docker/workflow.md)
- [brctl](/OS/Linux/brctl.md) : 管理以太网桥, 在内核中建立, 维护, 检查网桥配置. 
- [Hadoop配置参考](http://blog.csdn.net/xu470438000/article/details/50512442)
- [Hadoop入门](http://www.cnblogs.com/xia520pi/archive/2012/05/16/2503949.html)
- [Datanode 注册分析流程](http://blog.csdn.net/tbdp6411/article/details/24416847)
