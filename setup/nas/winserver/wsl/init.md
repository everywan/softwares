# wsl自启动配置
wsl自启动 + ssh 自启动

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