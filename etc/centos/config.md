# 配置

## 前置配置
### 配置网络
nmtio(NetworkManager TUI) 网络管理文本用户界面, 用于以TUI的方式管理网络. centos7 默认包含 nmtui, 这里我们使用此工具配置wifi.
1. 查看现有wifi: `nmcli d wifi`
2. 连接wifi:  `nmcli d wifi connect ssid password "pwd"`
3. 添加/配置配置文件. 参考: [静态IP配置](/soft/static-ip.md)

### 配置用户
添加用户: `useradd -m -g users -G wheel wzs`: 将 `wzs` 换为你的名字
- 修改密码:`passwd wzs`
- users 是所有普通用户的集合(相较与如docker等用户而言). 也被称为 staff 组
- wheel 是一个特殊组, 包含root权限

### 磁盘扩容
树梅派默认根目录分区比较小, 参考如下链接. [磁盘扩容](/develop/disk.md#分区扩容)

## 推荐配置
需要手动修改以下配置
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
2. 更改默认shell命令: `chsh`
3. 复制自己的公钥, 设置免密登录: 将共要复制到宿主机(树梅派)的 `.ssh/authorized_keys` 文件中.
  - `ssh-copy-id -i file.pub root@172.26.10.20`

设置时区/时间同步 等参见arch

### 配置EPEL源

```Bash
cat << EOF > /etc/yum.repos.d/epel.repo
[epel]
name=Epel rebuild for armhfp
baseurl=https://armv7.dev.centos.org/repodir/epel-pass-1/
enabled=1
gpgcheck=0
EOF
```
## 影音系统
> 参考: [树莓派3B+CentOS7安装Aria2+WEBUI](https://www.jianshu.com/p/e8eed46e938e)

aria2 除了不支持ed2k下载外, 其他均已支持. 且可以通过网站管理
1. 安装: 如果已经配置EPEL源, 则直接使用 yum 安装即可; 或者参考链接 从源码安装.
2. 配置: 参考链接
3. 启动: 使用 `aria2c --conf-path=config` 启动验证配置是否正确. 使用 `aria2c --conf-path=config -D` 以守护进程的形式启动.
4. 安装 aria2WebUI: `wget https://github.com/straightedge4life/webui-aria2/archive/master.zip`, 然后将文件使用nginx等代理即可. 详细参考链接

使用 systemd 管理 aria2
1. 添加 service 脚本: `vim /lib/systemd/system/aria2.service`
    ```Bash
    [Unit]
    Description=Aria2c download manager
    Requires=network.target
    After=dhcpcd.service
        
    [Service]
    Type=forking
    User=root
    RemainAfterExit=yes
    ExecStart=/usr/bin/aria2c --conf-path=/root/.aria2/aria2.conf --daemon
    ExecReload=/usr/bin/kill -HUP $MAINPID
    RestartSec=1min
    Restart=on-failure
        
    [Install]
    WantedBy=multi-user.target
    ```
2. 刷新 systemd: `systemctl daemon-reload`
3. 启动&&自启 aria: `sudo systemctl enable aria2 && sudo systemctl start aria2`

Nginx 配置: 当使用 EPEL 源时, 直接从 源安装即可, 且支持 systemd 管理.
1. 安装&设置自启: `sudo yum install nginx && sudo systemctl enable nginx && sudo systemctl start nginx`
2. 复制 aria2WebUI 静态资源到 nginx 静态资源目录
3. 配置防火墙, 开启 80 端口. (公网建议修改为其他端口)
    ```Bash
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    # aria rpc 端口
    sudo firewall-cmd --zone=public --add-port=6800/tcp --permanent
    sudo firewall-cmd --reload
    ```

注意
1. centos7 默认是启用 selinux 的. 所以当 selinux 验证不通过时, 使用 systemctl 启动会报错. (systemd脚本启动会通过selinx的认证)
    - 原文: `Nginx will fail to start if /run/nginx.pid already exists but has the wrong SELinux context.`, 文件路径: `/usr/lib/systemd/system/nginx.service`

### 支持NTFS
`yum install ntfsprogs.armv7hl`

## 参考
1. [为树莓派装上 CentOS 7 系统](https://sspai.com/post/42793)
