# 端口映射
基于端口映射实现内网穿透等功能

使用frp软件进行内网穿透, 配置参考官网 [frp](https://github.com/fatedier/frp/blob/master/README.md).

frp 可以通过编写脚本实现由 systemd 管理, 脚本编写方式参考 [systemd](/develop/systemd.md#systemd脚本), 脚本参考 [frpc](./service/frpc.service) [frps](./service/frps.service)