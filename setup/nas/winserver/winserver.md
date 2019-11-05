# winserver
使用 windows server 2019 作为nas.

开启远程桌面连接, 教程见网络. 注意, 如果想要使用 rdesktop, 需要关闭验证: 高级系统设置->远程->关闭网络级别身份验证.

手机安装 `Microsoft RD Client` 即可

arch 安装 rdesktop. 连接示例: `rdesktop -g 1920x1080 -d pc -u wzs 192.168.31.169:3389`

## 配置
1. 创建新用户, 更改电脑名称, 组织名称
2. 将用户改为管理员类型: 在 控制面板/账户 里
3. 服务器管理工具中, 启用 远程桌面/wsl

启用sshd [wsl-sshd](./setup/sshd.md)

安装其他软件
1. chrome
2. 迅雷vip (可从腾讯市场下载)
3. plex server: 登录之后, 官网下载即可.

