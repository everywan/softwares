## 静态IP配置
虽然不同系统下略有不同, 但是大致思路都是类似的, 现示例如下(默认以centos为准)

一般而言, 网络链接 由系统 network 服务管理. centos network 默认从 `/etc/sysconfig/network-scripts/` 下读取相关配置文件启动网络.

修改完成后, 可重启网络, 使配置生效: `systemctl restart network`

### 信息查看
1. 查看网关: 
    ````
    # ip route show
    default via 10.0.1.1 dev wlp0s20f3 proto dhcp src 10.0.1.73 metric 302 
    10.0.1.0/24 dev wlp0s20f3 proto dhcp scope link src 10.0.1.73 metric 302
    # via 后的地址就是网关
    ````
2. 查看DNS: `cat /etc/resolv.conf`.

### 配置文件
```Conf
# 文件位置, xxx为网络名称, 没有后缀
# vim /etc/sysconfig/network-scripts/ifcfg-xxxx
HWADDR=B8:27:EB:70:0F:A4
ESSID="xxx"
MODE=Managed
KEY_MGMT=WPA-PSK
SECURITYMODE=open
MAC_ADDRESS_RANDOMIZATION=default
TYPE=Wireless
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME="xxx"
UUID=bf0555dc-7ed8-4a8a-8cc3-5ab88448544d
# 主要在这里
ONBOOT=yes              # 是否开机自启
BOOTPROTO=static        # static: 静态. dhcp: 动态IP
IPADDR=10.0.1.174
GATEWAY=10.0.1.1
DNS1=219.141.136.10
DNS2=8.8.8.8
```