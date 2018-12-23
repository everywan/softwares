## 配置
### 网络配置-wifi
centos7 自带 nmtui 工具, 可以使用以下命令连接wifi: `nmcli d wifi connect ssid password "pwd"`

nmtio(NetworkManager TUI): 网络管理文本用户界面, 用于以TUI的方式管理网络.

也可以直接修改/添加 `/etc/sysconfig/network-script/ifcfg-wlan0` 文件, centos network 默认从这里读取网络配置文件(注意将 `wlan0` 修改为自己的无线网卡名称)
1. 添加配置文件如下
    ```Bash
    TYPE="wireless"
    BOOTPROTO="static" #dhcp改为static 
    DEFROUTE="yes"
    PEERDNS="yes"
    PEERROUTES="yes"
    IPV4_FAILURE_FATAL="no"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_PEERDNS="yes"
    IPV6_PEERROUTES="yes"
    IPV6_FAILURE_FATAL="no"
    NAME="wlan0"
    UUID="xxx-xxx"
    ONBOOT="yes" #开机启用本配置
    IPADDR=192.168.7.106 #静态IP
    GATEWAY=192.168.7.1 #默认网关
    NETMASK=255.255.255.0 #子网掩码
    DNS1=192.168.7.1 #DNS 配置
    ```
2. 重启网络: `systemctl restart network`