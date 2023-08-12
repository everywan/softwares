# ssh
- [参考arch文档](https://wiki.archlinux.org/index.php/Secure_Shell_(简体中文))

## 登录
1. SSH免密登录流程
    - ssh客户端使用 ssh-keygen 生成公钥/秘钥. `ssh-keygen -t rsa -f ~/.ssh/file`. 不需要密码则一直回车即可
    - 复制 .pub 公钥文件到sshd服务端的 `~/.ssh/authorized_keys` 中
        - `ssh-copy-id -i file.pub root@172.26.10.20`
        - `scp file.pub root@172.26.10.20:~/.ssh/`　然后在服务器端, `cat ~/.ssh/file.pub>> ~/.ssh/authorized_keys`
    - 修改服务器文件权限
        ```Bash
        chmod 600 authorized_keys
        chmod 700 ~/.ssh
        ```
    - 修改 sshd 配置
        ```Bash
        # sudo vim /etc/ssh/sshd_config
        RSAAuthentication yes
        PubkeyAuthentication yes
        ```
    - 验证完毕后, 可以关闭密码登录: `PasswordAuthentication no`
2. SSH免密登录多台机器
    - 一对公钥/私钥可以重复使用到多台服务器, 所以大多数情况没有必要生成多个
    -  将公钥复制到服务端后, 在客户端创建 `~/.ssh/config` 文件, 添加以下配置
        ````
        Host server1
            HostName 172.26.10.20
            User root
            IdentityFile /root/.ssh/server1
        ````
    - 使用 `ssh server1` 即可免密登录服务器. 如需添加多台，再添加配置文件即可
3. 如果遇到什么问题
    - 使用 `-vvv` 参数查看调试
    - 查看man文档, 研究下配置文件以及其注释说明

## 端口转发
通俗来讲, ssh端口转发 就是当你请求指定地址时, 将该请求通过ssh隧道, 转发到另一个地址.

端口转发可以认为是代理的一部分和具体实现.

ssh 有三种端口转发方式: 本地转发, 远程转发, 动态转发.

本地转发是指将所有访问 本地主机:端口 的报文, 转发到远程主机的指定端口.
使用本地转发, 访问本地端口 其实是在 访问远程端口.

远程转发是指将所有访问 远程主机:端口 的报文, 转发到其他主机(本地可以访问)的指定端口.
使用远程转发, 访问远程端口其实是在访问 本地环境(本地或本地能访问的某个ip) 的某个端口

动态转发 将在本地启动一个socket监听者, 将访问 本地主机A:端口 的请求全部通过socket都转发远程主机,
然后解析请求并转发.

动态转发我没有用过, 还需要在看看.

----
实现原理
1. 本地转发启动服务监听本地端口, 当监听到请求时将其转发.
2. 远程转发首先通过ssh在远程服务器执行命令, 启动服务监听指定端口, 当监听到请求时将其转发到本地, 然后请求.
3. 动态转发在本地启动socket服务器, 监听本地端口, 当监听到请求时, 解析请求并转发.

----
相同点
1. 使用ssh实现的端口转发都由ssh隧道发送.
2. 本地转发/远程转发 参数格式相同, 都是 `请求源地址:转发目的地址`

区别

本地转发/远程转发 将 机器:端口 的报文*直接*转发到 目标机器:端口, 不做任何处理.
因此两个端口的应用层协议是一般是相同的, 否则会解析失败. 
如服务器的22端口只解析ssh请求, 当本地发送http请求时就会发生错误, 因为远程端口只解析ssh请求.

而动态转发使用socket协议实现, 启动动态转发将会在本地启动一个socket监听者, 访问动态端口的数据由ssh隧道
转发, 并且根据报文中指定的协议和地址去请求相应的数据.

### 使用示例
本地转发
```Bash
# 方法签名
ssh -fCN -L [机器A的IP或省略]:[A端口]:[远程机器B的IP或省略]:[B端口] [登陆B机器的用户名@服务器IP]
# 因为要监听机器A的某个端口, 所以该IP必须是本地注意的网卡ip

# 代理3306端口, 本地所有访问 localhost:3306 的报文被转发至 xgxw.com:3306
ssh -fNg -L 3306:localhost:3306 -p 22 wzs@xgxw.com

# 本地所有访问 本地:8080 的报文都转发到 xgxw.com:80
ssh -fNg -L 8080:xgxw.com:80 -p 22 wzs@test.xgxw.com

# 参数介绍
# -C: 压缩所有数据.
# -f: Requests ssh to go to background just before command execution. 即在执行命令前将ssh在后台执行. 会将
#   ssh stdin 重定向到 /dev/null
# -N: Do not execute a remote command.  This is useful for just forwarding ports
```

远程转发
```Bash
# 方法签名
ssh -fCN -R [B机器IP或省略]:[B机器端口]:[C机器的IP]:[C机器端口] [登陆B机器的用户名@服务器IP]

# 所有访问 xgxw.com:3306 的报文都转发到 localhost:3306, localhost 是值本机.
ssh -fNg -R 3306:localhost:3306 -p 22 wzs@xgxw.com

# 所有访问 xgxw.com:3306 的报文都转发到 test.xgxw.com:3306.
ssh -fNg -R 3306:test.xgxw.com:3306 -p 22 wzs@xgxw.com
```

动态转发
```Bash
# 方法签名
ssh -fCN -D [A机器IP或省略]:[A机器端口] [登陆B机器的用户名@服务器IP]

# 所有访问本地8080端口的报文都转发到 xgxw.com,
ssh -fNg -D 8080 -p 22 wzs@xgxw.com
```

## 其他
### autossh
反向代理不会自动重连, 可以使用 autossh 工具建立反向代理(详细参考 arch 官方文档的做法)

使用 systemd 管理autossh时, 首先请先设置免密登录, 然后将密钥拷贝到 `/root/.ssh` 下, 权限修改为 600.
否则在 systemd 启动autossh 时, 会因为没有权限连接而报错(`ssh error status 255`).
也可以使用export脚本自动输入密码, 但是明显不如上面那个方法好

使用systemd托管autossh服务
```Bash
# arch 系统安装autossh. 注意保持 sshd 服务的开启
sudo pacman -S autossh
# 2223 监听端口 其他格式与 ssh 建立反向代理相同
autossh -M 2223 -fCNR 2222:localhost:22 user@ip

vim /etc/systemd/system/autossh.service
# [Unit]
# Description=AutoSSH service for port 2222
# After=network.target

# [Service]
# Type=forking
# Environment="AUTOSSH_GATETIME=0"
# ExecStart=/usr/bin/autossh -M 0 -NL 2222:localhost:2222 -o TCPKeepAlive=yes -i /root/.ssh/id_rsa foo@bar.com

# [Install]
# WantedBy=multi-user.target

# 然后就可以使用 systemd 管理autossh了
```
