# 端口映射
基于端口映射实现内网穿透等功能

使用frp软件进行内网穿透/p2p, 配置参考官网 [frp](https://github.com/fatedier/frp/blob/master/README.md).
- 内网穿透用于登录等小流量高网速操作, p2p 用于传输大文件

frp 可以通过编写脚本实现由 systemd 管理, 脚本编写方式参考 [systemd](/doc/systemd.md#systemd脚本), 脚本参考 [frpc](./service/frpc.service) [frps](./service/frps.service)

配置示例如下

```INI
# frpc
[common]
server_addr = xxx
server_port = 6000

[ssh_pc]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = xxx

# smb 客户端配置
[p2p_smb_visitor]
type = xtcp
role = xxx
server_name = p2p_smb
# 只有 sk 一致的用户才能访问到此服务
sk = xxxxx
bind_addr = 127.0.0.1
bind_port = 445

# smb 服务端配置, 提供数据的一方
[p2p_ssh]
type = xtcp
sk = xxxxx
local_ip = 127.0.0.1
local_port = 445
```

```INI
# frps
[common]
bind_port = 6000
# p2p 需要开通 udp 端口
bind_udp_port = 7000
```
