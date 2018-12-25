## 配置
### 网络配置-wifi
1. 使用现有工具链接wifi: centos7 自带 nmtui 工具, 可以使用以下命令连接wifi: `nmcli d wifi connect ssid password "pwd"`
    - nmtio(NetworkManager TUI): 网络管理文本用户界面, 用于以TUI的方式管理网络.
2. 添加/配置配置文件. 参考: [静态IP配置](/develop/static-ip.md)