# Shadowsocks

## 搭建 shadowsocks 服务端
1. shadowsocks 下载和安装
    - 下载`git clone https://github.com/shadowsocks/shadowsocks.git`
    - 切换分支: `git checkout origin/master -b master`
    - 安装 `sudo python setup.py install`
2. json配置文件参考
    ````
    {
        "server":"0.0.0.0",
        "server_port":50000,
        "password":"***",
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open":false,
        "workers": 1
    }
    ````
3. 启动服务: `ssserver -c /etc/shadowsocks/shadowsocks.json -d start`
3. 终止服务: `ssserver -c /etc/shadowsocks/shadowsocks.json -d stop`
4. 建议:
    - 如果是自己搭建, 建议端口设置的随机一点. 不然会被其他的陌生人侦测到, 无节制的蹭网影响正常使用
    - 如果不想自己搭建,可以去 shadowsocks 官网购买账号, 网速很稳定, 但可能被封. 一年16刀(需要翻墙才能访问)
5. 国外服务器推荐
    - 微软云, 按量付费模式
    - 阿里云, 国外节点, 入门主机即可. 
    - Amazon, 新注册用户绑定信用卡后免费用一年乞丐版主机. 网速不太稳定.

## 客户端连接 socket 代理服务
1. win下,启动 shadowsocks客户端 会直接将socket代理转为HTTP代理.
1. linux下, 使用 `sslocal -c /etc/shadowsocks/shadowsocks.json -d start` 启动 本地socket代理
    - 如果系统不支持 socket代理,那么可以使用privoxy程序实现socket代理转http代理
    - json配置文件参考
    ````
    {
        "server":"sslserverIp",
        "server_port":serverPort,
        "local_address": "127.0.0.1",
        "local_port":localPort,
        "password":"***",
        "timeout":300,
        "method":"aes-256-cfb"
    }
    ````
1. 建议:
    - 若不需要全局代理, 建议使用 chrome 的 SwitchyOmega 插件, 支持 socket 代理.
    - 使用 `auto switch` 模式. 这里推荐一个长期更新的代理规则列表 `https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt` ,可以很好的实现路由分流,提升访问速度
    - 如果使用的国外服务器网速不太稳定, 可以使用阿里云ECS等可以稳定链接国外服务器的国内服务器做中转. 不过存在国内服务器被封的情况

### 搭建HTTP代理服务
> 使用 privoxy 程序实现

1. 下载privoxy, 并安装(阿里源有此软件, 可以直接 `apt install`)
2. 配置 config 文件,添加以下行,实现socket代理转http代理
    ```Bash
    # 监听socket服务的端口, 如果要对外提供服务, 127.0.0.1 改为 0.0.0.0
    forward-socks5t / 127.0.0.1:1080    .
    # http服务的监听端口,建议取一个随机的五位数值
    listen-address  0.0.0.0:8118
    ```
3. 启动privoxy服务 `systemctl restart privoxy`
4. 注意防火墙不要禁用相关端口
5. privoxy 本身不支持用户功能.

## ss中转
有时我们有这样的需求: 本地网络访问海外服务器IP不稳定, 时断时序或者干脆直接连不上了, 这是可以通过远程中转的方式解决次问题. (需要你有一台稳定的公网服务器)

配置
1. 海外服务器 * 1: 有公网IP
2. 境内服务器 * 1: 有公网IP

在境内服务器上通过 frp/autossh 等工具, 映射海外服务器的ss端口即可解决.
1. 配置与介绍: [端口映射](/soft/doc/port-mapping.md)
2. frpc/frps 安装: 在本项目 `/setup` 目录下寻找相应系统的安装脚本

## 知识点
1. `0.0.0.0` 是什么
    - [参考网站](http://www.cnblogs.com/hnrainll/archive/2011/10/13/2210101.html)
    - RFC: 0.0.0.0/8 Addresses in this block refer to source hosts on "this" network. Address 0.0.0.0/32 may be used as a source address for this host on this network; other addresses within 0.0.0.0/8 may be used to refer to specified hosts on this network _([RFC1122], Section 3.2.1.3)_
    - 根据RFC文档描述，它不只是代表本机，0.0.0.0/8可以表示本网络中的所有主机，`0.0.0.0/32` 可以用作本机的源地址，`0.0.0.0/8`也可表示本网络上的某个特定主机,综合起来可以说`0.0.0.0` 表示整个网络
    - `0.0.0.0` 表示当前网络(仅作为源地址有效). [参考](https://en.wikipedia.org/wiki/IPv4)
    - 在路由器配置中可用`0.0.0.0/0`表示默认路由，作用是帮助路由器发送路由表中无法查询的包
    - 通过测试，可得知ECS是不能ping通自身的公网IP
2. [ShadowSocks简介](https://vc2tea.com/whats-shadowsocks/)
    - 客户端发出的请求基于 Socks5 协议跟 ss-local 端进行通讯，由于这个 ss-local 一般是本机或路由器或局域网的其他机器，不经过 GFW，所以解决了 GFW 通过特征分析进行干扰的问题 - ss-local 和 ss-server 两端通过多种可选的加密方法进行通讯，经过 GFW 的时候是常规的TCP包，没有明显的特征码而且 GFW 也无法对通讯数据进行解密 
    - ss-server 将收到的加密数据进行解密，还原原来的请求，再发送到用户需要访问的服务，获取响应原路返回
    - ![](attach/shadowsocks.png)
