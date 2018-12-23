https://www.cnblogs.com/jiangtu/p/6883618.html

### 配置网络
```Bash
cd /etc/sysconfig/network-script
vi 要编辑的网卡
更改 onboot = yes
# 重启network
systemctl restart network
```

安装ssh
```Bash
#检测SSHD服务是否开启
systemctl status sshd
#如果sshd服务没有安装，那么使用yum安装sshd
yum -y install openssh-server
#启动sshd服务
systemctl start sshd
#检测22端口是否开启
netstat -na|grep 22
```