## Mac虚拟机配置
Mac毕竟不是Linux, 还是更习惯将某些偏服务端的程序放到Linux上运行.

### 配置privoxy
privoxy用于设置HTTP代理或者将socket代理转为http代理.
- 安装教程参见 [init.sh - install_privoxy](./init.sh)
- [privoxy 配置教程](/collect/soft/shadowsocks.md#搭建HTTP代理服务)

添加到 systemd, 使用 systemctl 管理服务
1. 添加到 systemd:
    - 编写脚本: [privoxy.service-脚本参考](./privoxy.service)
    - 添加服务脚本到 `/etc/systemd/system/multi-user.target.wants/` 下
    - 重启systemd守护进程: `sudo systemctl daemon-reload`
2. 使用以下命令检测是否成功
    ```Bash
    sudo systemctl start privoxy.service
    sudo systemctl status privoxy.service
    ```