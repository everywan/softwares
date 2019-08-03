# 云盘

云盘有几种方案
1. 使用现有的商业方案, 此处推荐坚果云, 收费但是价格/速度都还可以.
2. 使用开源方案, 需要自备服务器. 推荐 阿里/腾讯云ECS, 搭配 NextCloud 或 Syncthing.
  - NextCloud 功能上更像传统云盘, 而 Syncthing 主要用于个设备文件同步
3. 自己开发, 借助 oss/ecs 存储数据, 借助 fsync/upload 传输数据, 借助 inotify 监听文件更改(仅限linux).

[NextCloud-docker](https://github.com/nextcloud/docker): 与正常云盘功能类似, 可以同步照片, 通讯录等. 全平台支持, linux界面比较老.

[Syncthing](https://github.com/syncthing/syncthing): 注重各设备之间的文件同步, 全平台支持, 使用Go语言编写.

arch 下可使用 incron 命令监听数据, 或者借助 inotify api 自己写程序监听. inotify 更多信息参考 `man inotify`

ecs rsync 同步命令:
```Bash
rsync -qarP -pog --timeout=60 /data/cloud wzs@default:/home/wzs/
```

ossutil 同步命令:
```Bash
/usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur /data/cloud/ oss://cloud
```

## 内网穿透

方案一: 使用 frp/autossh 等软件, 仅需一台有公网IP的服务器即可.
- 实现: 局域网机器通过 autossh/frp 将端口映射到远程服务器, 然后外网就可以通过该端口访问局域网机器.
- 缺点: 比较以来公网服务器的带宽. 外网与局域网通信需要经过公网服务器中转. 考虑到当公网服务器不稳定时, 局域网需要启动守护进程保证链接持续.
- 参考 [端口映射](/doc/port-mapping.md)

方案二: 使用 ddns, 需要域名, 以及局域网是公网IP(可以是动态分配的).
- 实现: 在路由器上查找 ddns 功能(一般在 `应用` 中), 然后根据提示设置即可.

ddns 介绍: 一种自动更新名称服务器的技术, 根据互联网的域名订立规则, 域名必须跟从固定的IP地址. 但动态DNS系统为动态网域提供一个固定的名称服务器(Name server), 透过即时更新, 使外界用户能够连上动态用户的网址.

