- [systemd](#systemd)
  - [systemd脚本](#systemd%E8%84%9A%E6%9C%AC)
    - [脚本示例](#%E8%84%9A%E6%9C%AC%E7%A4%BA%E4%BE%8B)
  - [启动脚本](#%E5%90%AF%E5%8A%A8%E8%84%9A%E6%9C%AC)

# systemd
> 参考 [systemd](https://wiki.archlinux.org/index.php/systemd_(简体中文))

## systemd脚本
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

### 脚本示例
- [frpc.service](./service/frpc.service)
- [frps.service](./service/frps.service)
- [autossh.service](./service/autossh.service)

## 启动脚本
```Bash
systemctl daemon-reload       # 重载系统服务
systemctl enable *.service    # 设置某服务开机启动      
systemctl start *.service     # 启动某服务  
systemctl stop *.service      # 停止某服务 
systemctl reload *.service    # 重启某服务

# systemctl 同时支持电脑的 挂起/休眠
systemctl suspend             # 挂起
```