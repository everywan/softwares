# winserver
使用 windows server 2019 作为nas.

开启远程桌面连接, 教程见网络. 注意, 如果想要使用 rdesktop, 需要关闭验证: 高级系统设置->远程->关闭网络级别身份验证.

手机安装 `Microsoft RD Client` 即可

arch 安装 rdesktop. 连接示例: `rdesktop -g 1920x1080 -d pc -u wzs 192.168.31.169:3389`

## 配置
1. 创建新用户
2. 将用户改为管理员类型: 在 控制面板/账户 里
3. 服务器管理工具中, 启用 远程桌面/wsl

windows-server-2019 安装 wsl, 并启用 sshd
1. 启用wsl: 打开 powershell, 执行 `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
2. 下载 ubuntu: `https://aka.ms/wsl-ubuntu-1804`. 推荐使用迅雷下载
3. ubuntu.appx 改名为 ubuntu.zip, 解压然后双击 exe 安装
4. 启用sshd
  - 停止系统自带的ssh服务: 打开 服务, 然后禁用 `OpenSSH...` 服务
  - 启用 wsl 的 ssh 服务: `sudo apt purge openssh-server; sudo apt install openssh-server`
  - 开放端口: 打开 `防火墙` -> 打开 `高级` -> 添加入站规则
5. sshd 添加开机自启

安装其他软件
1. chrome
2. 迅雷vip (可从腾讯市场下载)


## 附录
sshd 添加自启动
1. 编写linux启动脚本:
    ```Bash
    # sudo vim /etc/init.d/wsl_init.sh
    #! /bin/sh
    /etc/init.d/cron $1
    /etc/init.d/ssh $1
    ```
2. 添加权限, 免密执行脚本
    ```Bash
    chmod +x /etc/init.d/wsl_init.sh
    # chmod ... && vim /etc/sudoers
    %sudo ALL=NOPASSWD: /etc/init.d/wsl_init.sh
    ```
3. 添加到win自启
    ```Bash
    # win+r 后 执行 `shell:startup`, 在该目录创建脚本
    # vim wsl_init.vbs
    Set ws = CreateObject("Wscript.Shell")
    ws.run "wsl.exe sudo /etc/init.d/wsl_init.sh start", vbhide
    ```
