# 手动配置

## 配置网络
nmtio(NetworkManager TUI) 网络管理文本用户界面, 用于以TUI的方式管理网络. centos7 默认包含 nmtui, 这里我们使用此工具配置wifi.
1. 查看现有wifi: `nmcli d wifi`
2. 连接wifi:  `nmcli d wifi connect ssid password "pwd"`
3. 添加/配置配置文件. 参考: [静态IP配置](/doc/static-ip.md)
  - centos 配置文件在: `/etc/sysconfig/network-scripts/ifcfg-*`
4. 配置防火墙, 开启 80 端口. (公网建议修改为其他端口)
    ```Bash
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    sudo firewall-cmd --reload
    ```

## 配置用户
添加用户: `useradd -m -g users -G wheel wzs`: 将 `wzs` 换为你的名字
- 修改密码:`passwd wzs`
- users 是所有普通用户的集合(相较与如docker等用户而言). 也被称为 staff 组
- wheel 是一个特殊组, 包含root权限

## 其他
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
2. 更改默认shell命令: `chsh`
3. 复制自己的公钥, 设置免密登录: 将共要复制到宿主机的 `.ssh/authorized_keys` 文件中.
  - `ssh-copy-id -i file.pub root@172.26.10.20`
