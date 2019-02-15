- [Arch Linux 配置](#arch-linux-%E9%85%8D%E7%BD%AE)
  - [预先配置](#%E9%A2%84%E5%85%88%E9%85%8D%E7%BD%AE)
    - [添加用户](#%E6%B7%BB%E5%8A%A0%E7%94%A8%E6%88%B7)
    - [连接WIFI](#%E8%BF%9E%E6%8E%A5wifi)
    - [恢复备份](#%E6%81%A2%E5%A4%8D%E5%A4%87%E4%BB%BD)
    - [中文支持](#%E4%B8%AD%E6%96%87%E6%94%AF%E6%8C%81)
  - [收尾配置](#%E6%94%B6%E5%B0%BE%E9%85%8D%E7%BD%AE)
    - [电源管理](#%E7%94%B5%E6%BA%90%E7%AE%A1%E7%90%86)
    - [硬件配置](#%E7%A1%AC%E4%BB%B6%E9%85%8D%E7%BD%AE)
    - [其他软件配置](#%E5%85%B6%E4%BB%96%E8%BD%AF%E4%BB%B6%E9%85%8D%E7%BD%AE)
  - [链接](#%E9%93%BE%E6%8E%A5)

# Arch Linux 配置

## 预先配置
### 添加用户
1. 添加用户: `useradd -m -g users -G wheel wzs`
2. 修改密码: `passwd wzs`
3. 如果 wheel组 没有 sudo 权限, 则为 wheel组 开通 sudo 权限.

### 连接WIFI
1. `sudo systemctl start start/stop/status/enable netctl@profile`： 当安装系统时同时安装了 `wpa_supplicant`, 并拷贝了配置文件, 便可执行此命令连接到指定网络
   1. profile 只是文件名称, 不含路径
2. `sudo wifi-menu`: 已安装 `wpa_supplicant`, 但是没有配置文件时.
3. 如果没有 `wpa_supplicant`, 那么请连接到无需密码的有线网络, 或者切换到U盘启动, 为此系统安装 `wpa_supplicant`. 具体参考 arch安装教程
4. 其他
   1. [WIFI 自动切换参考自动脚本](./setup.d/8-netctl_auto.sh)
   2. [静态IP配置](/doc/static-ip.md). 可参考 arch 默认的配置示例(位置 `/etc/netctl/example/`)

### 恢复备份
一般而言, 如果不是首次安装的话, 通常会将配置文件保存在云上, 之后重装系统时从云上恢复. 这里我是将配置存储到 oss, 具体恢复方法参考 [oss-restore](./setup.d/9-restore_backup.sh), 同样, 在这个脚本里对配置文件进行了恢复. 根据自己需要更改此文件.

### 中文支持
首次安装参考 [Linux中文支持](/doc/chinese.md).

重装恢复简易流程如下
```Bash
sudo vim /etc/locale.gen
# 取消 `zh_CN.UTF-8 UTF-8` 和 `en_US.UTF-8 UTF-8` 前的注释
sudo locale-gen
ln -s ~/cloud/backup/config/xinitrc ~/.xinitrc

sudo pacman -S fcitx-im
yay -S fcitx-sogoupinyin
# 然后在 `.config/fcitx/profile` 中启用相应的拼音输入法
ln -s ~/cloud/backup/config/xprofile ~/.xprofile
```

## 收尾配置
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
    - use zsh like vim: `bindkey -v`
2. 更改默认shell命令: `chsh`
3. 备份系统: [备份系统](/doc/script/backup.sh)
4. 重启系统

### 电源管理
首次安装参考 [电源管理](/doc/power-manger.md)

休眠支持 简易流程如下
```Bash
# 创建, 挂载 swap 分区, 大小为内存大小. 具体参考 arch 安装教程

# 修改默认情况下内存dump到硬盘占用空间的大小. 这里是 32G.
sudo tee /etc/tmpfiles.d/modify_power_image_size.conf <<< "w /sys/power/image_size - - - - 34359734272"

sudo vim /etc/default/grub
# 示例, 注意更换 /dev/sda3 为自己电脑上 交换分区 的位置
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable"  ==> GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable resume=/dev/sda3"
# 更新 grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo vim /etc/mkinitcpio.conf
# 示例, 添加 resume
HOOKS="base udev autodetect modconf block filesystems keyboard fsck" ==> HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"
# 重新生成 initramfs 镜像
sudo mkinitcpio -p linux
```

DMS配置
```Bash
sudo vim /etc/systemd/logind.conf
# 修改配置
sudo systemctl restart systemd-logind
```

### 硬件配置
首次安装参考 [硬件配置](/doc/hardware.md)

亮度调节 简易流程如下
```Bash
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod 664 /sys/class/backlight/intel_backlight/brightness
sudo usermod -a -G video wzs
# 将 /doc/script/backlight.sh 添加到 $PATH
# 恢复 i3 配置文件. 其中包含快捷键映射
vim /etc/udev/rules.d/99-backlight.rules
# ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

显卡配置: 未整理

### 其他软件配置

**chrome**

chrome 首次登录下载 SwitchOmega 需要翻墙, 因为我使用 ss 搭的梯子, 基于ss这里有两种办法
1. 设置Socket环境变量, 然后在当前shell打开chrome, 此时chrome可以通过ss翻墙.
   1. 设置socket版本: `export SOCKS_VERSION=5`
   2. 设置socket服务器: `export SOCKS_SERVER="http://127.0.0.1:1080"`
   3. 启动 chrome
2. 设置http_proxy环境变量, 通过HTTP代理翻墙. HTTP 代理可通过 Provixy 实现(Provixy可以将socket代理转为http代理). 此处不再详述

## 链接
1. [arch_推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
2. [arch_常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)
