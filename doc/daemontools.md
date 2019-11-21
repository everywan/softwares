# daemon守护进程

守护进程是一种在后台执行的进程. 一般使用进程管理工具管理守护进程的状态(start/stop/restart/enable等).

守护程序如 sshd.

进程管理工具如 SysV_init/systemd/supervise.

## 发展历程
Linux系统的各种服务是如何被唤醒的

SysV_init 历史, 简介

service

systemd

supervise: supervise 一般用于管理自定义的程序, 比 systemd 更偏向用户, 如管理自己后台网站服务的状态(start/stop)

## systemd

> 参考 [systemd](https://wiki.archlinux.org/index.php/systemd_(简体中文))

### systemd脚本
service 脚本位置一般按如下规则存储
- `/usr/lib/systemd/system`: 软件包安装的systemd单元
- `/etc/systemd/system`: 管理员安装的systemd单元, 优先级比 `usr/lib` 高

脚本类型
- `target`: 开机启动级别
- `service`: 服务文件

servcie 脚本一般分为三部分
```Bash
[Unit]                # 主要是服务说明
Description=xxx       # 服务描述
After=xx.target       # 启动顺序: 在指定服务启动后才启动该服务, 常用的如 network.target
Before=xx.service     # 启动顺序: 在指定服务启动前启动该服务

[Service]             # 服务核心设置
Type=simple           # 后台执行方式
User=xx               # 服务执行的用户
Group=xx              # ..
KillMode=control-group  # 进程停止方式
PIDFile=xx.pid        # pid文件的绝对路径
Restart=no            # 服务进程退出后, systemd 的重启方式
ExecStart=xx.sh       # 启动服务时执行的命令
ExecReload=xx.sh      # 重启服务时执行的命令 
ExecStop=xx.sh        # 停止服务时执行的命令 
ExecStartPre=xx.sh    # 启动服务前执行的命令 
ExecStartPost=xx.sh   # 启动服务后执行的命令 
ExecStopPost=xx.sh    # 停止服务后执行的命令
PrivateTmp=true       # 给服务分配独立的临时空间

[Install]
WantedBy=multi-user.target  # 多用户
```

字段解释

Type

| 名称    | 解释                                                                                              |
| ------- | ------------------------------------------------------------------------------------------------- |
| simple  | 以ExecStart字段启动的进程为主进程                                                                 |
| forking | ExecStart字段以fork()方式启动: 此时父进程将退出,子进程将成为主进程(后台运行). 一般都设置为forking |
| oneshot | 类似于simple, 但只执行一次, systemd会等它执行完, 才启动其他服务                                   |
| dbus    | 类似于simple, 但会等待D-Bus信号后启动                                                             |
| notify  | 类似于simple, 启动结束后会发出通知信号, 然后systemd再启动其他服务                                 |
| idle    | 类似于simple, 但是要等到其他任务都执行完, 才会启动该服务                                          |

KillMode

| 名称          | 解释                                           |
| ------------- | ---------------------------------------------- |
| control-group | 当前控制组里的所有子进程, 都会被杀掉           |
| process       | 只杀主进程                                     |
| mixed         | 主进程将收到SIGTERM信号, 子进程收到SIGKILL信号 |
| none          | 没有进程会被杀掉, 只是执行服务的stop命令       |

#### 脚本示例
- [frpc.service](/doc/service/frpc.service)
- [frps.service](/doc/service/frps.service)
- [autossh.service](/doc/service/autossh.service)

### 启动脚本
```Bash
systemctl daemon-reload       # 重载系统服务
systemctl enable *.service    # 设置某服务开机启动      
systemctl start *.service     # 启动某服务  
systemctl stop *.service      # 停止某服务 
systemctl reload *.service    # 重启某服务

# systemctl 同时支持电脑的 挂起/休眠
systemctl suspend             # 挂起
```

## supervise
supervise: supervise 一般用于管理自定义的程序, 比 systemd 更偏向用户, 如管理自己后台网站服务的状态(start/stop)

supervisectl 常用命令
```Bash
supervisectl status # 查看所有服务状态
supervisectl start/stop/restart service # 管理服务(启动/etc..)
supervisectl reload   # 重载supervised, 一般用来重新加载配置文件
```

supervise 一般使用流程如下
1. 编写 supervisord.conf, 添加 program 配置
2. 编写启动命令, 有两种方式, 一是直接运行命令, 设置 SIGINT 为终止信号量即可. 第二可以编写启动脚本, 自定义终止信号量以及其他操作.

推荐使用脚本启动程序. 示例如下
```Bash
#!/bin/bash

_term() {
echo "Caught SIGTERM signal!"
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM  # 当接收到 SIGINT 信号时关闭程序

# 自定义处理, 启动进程时, 如果有 upload, 则用其作为执行文件
# 如此便可在 restart 时直接更换执行的进程, 而不必手动 stop/start
if [ -f example.upload ]; then
    mv example.upload example 
fi

./example --config=config.yaml
child=$!      ; 获取进程的pid
wait "$child" ; 等待进程结束
```

### 配置文件
supervise 自身配置
```Conf
# supervised conf
[unix_http_server]
file=/tmp/supervisor-www.sock   ; UNIX socket 文件，supervisorctl 与 supervised 交互

[supervisord]
logfile = /data/log/supervisord/www.log
logfile_maxbytes = 50MB
logfile_backups=10
loglevel = info
pidfile = /tmp/supervisord-www.pid
nodaemon = false
minfds = 1024
minprocs = 200
umask = 022
environment=JAVA_HOME="/data/server/jdk"

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor-www.sock
```

supervise 根据配置文件配置管理进程, 进程配置文件示例如下
```Conf
[program:example-go]
command=/data/www/example-go/run  ; 启动脚本
directory=/data/www/example-go
autostart=true
autorestart=true      ; 是否自动重启
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM       ; 终止信号, stop 进程时会发出
redirect_stderr=false
stdout_logfile=/data/log/supervisord/example-stdout.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=1
stdout_capture_maxbytes=0
stdout_events_enabled=false
stderr_logfile=/data/log/supervisord/example-stderr.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=1
stderr_capture_maxbytes=0
stderr_events_enabled=false
```
