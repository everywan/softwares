# Arch Linux 配置

执行脚本: `curl -sSL https://raw.githubusercontent.com/everywan/soft/master/os/arch/config.sh | sh -`

## 前置配置
### 配置网络
如果在安装系统时预先安装了 `wpa_supplicant`, 并且拷贝了网络配置文件, 则直接 `netctl start/stop/status/enable profile` 就可以启动链接.
- profile 只是文件名称, 不含路径
- 如果没有拷贝文件, 那么可以使用 `wifi-menu` 重新建立链接配置
- 如果没有安装 `wpa_supplicant`.  那么只能 要么插网线, 要么使用U盘启动系统, 安装相应软件.

安装`wpa_actiond`以自动切换wifi链接:
1. `sudo systemctl start netctl-auto@wlp4s0.service`, `sudo systemctl enable netctl-auto@wlp4s0.service`,
2. 其中的 `wlp4s0` 改为自己的无线网卡名

也可以通过配置文件管理网络. 具体参考: [静态IP配置](/develop/static-ip.md)
- arch 配置文件可以参考 `/etc/netctl/example/` 下的示例

### 添加用户
`useradd -m -g users -G wheel wzs`: 将 `wzs` 换为你的名字
- 修改密码:`passwd wzs`

## 软件安装配置
- [arch_推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
- [arch_常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)

- [wzs_安装脚本](./config.sh): 软件自动化安装配置脚本, 包括vim/ssh/nmap等基础工具, 也有 ss,docker,pip 等软件与配置.
    - 其实用 awk/sed 等可以实现更多的自动化配置, 但是太复杂了, 所以没用这个

建议先看下官方教程, 先选择自己需要那些软件, 最后写一个自己的自动化安装配置脚本.


### 手动安装/配置
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
2. 更改默认shell命令: `chsh`
3. 一指定目录为默认目录: `chroot`
4. tlp(电源管理软件) 采用默认配置即可
    - [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)

#### 登录管理配置
配置项为 logind.conf, 可通过 `man logind.conf` 查看具体值. 可以调节 电源按钮, 空闲触发的操作等.
- 配置文件路径: `/etc/systemd/logind.conf`
- 使配置生效: `systemctl restart systemd-logind`
- 参考 [笔记本设置](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd)
- [屏幕显示控制](https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%9C%A8_X_%E4%B8%AD%E8%AE%BE%E5%AE%9A_DPMS)

#### 备份系统
基本的安装配置后, 第一件事肯定是要先备份下系统, 然后就可以乱搞了...

这里使用 rsync 备份文件, 使用 acl 备份权限, 使用 tar 压缩备份, 使用 ossutil 上传备份到oss.

```Bash
# 备份系统, 恢复系统只需要换下 文件夹顺序就行了 
rsync -arpogv /* /backup/backup --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/backup/*}
# 备份权限(需要先安装 acl)
getfacl -R / > /backup/backup_permissions.txt
# 压缩备份
tar -jcvf /backup/backup.tar.bz2 /backup/backup
# 恢复权限
# setfacl --restore=backup_permissions.txt
```

#### 桌面/中文环境配置
- [参考: arch 桌面环境配置](./i3wm_config.md)

#### 多显示器配置
xrandr 是 X window 下管理多显示器的工具.

- [xrandr_arch_doc](https://wiki.archlinux.org/index.php/Xrandr_)

1. 安装: `sudo pacman -S xorg-xrandr`
2. 直接运行 `xrandr` 即可显示所有的显示器
2. 添加显示器: `xrandr --output HDMI-2 --auto --left-of eDP-1`
3. 关闭显示器: `xrandr --output HDMI-2 --off`

#### 时间同步
使用 systemd-timesyncd 进行时间同步. _systemd-timesyncd 是一个用于跨网络同步系统时钟的守护服务_.
1. [参考: systemd-timesyncd_arch](https://wiki.archlinux.org/index.php/Systemd-timesyncd_)
2. 启动 systemd-timesyncd, 设置自动同步: `sudo timedatectl set-ntp true`
2. 配置时间同步服务器: `/etc/systemd/timesyncd.conf`
    ````
    [Time]
    NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
    FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
    ````

#### 回收站
arch 默认没有回收站功能, 删除会直接 rm 掉, 偶尔让你变得很难受. 所以使用 `trash-cli` 实现回收站功能
1. 设置 rm 为移动到到回收站: `vim ~/.zshrc`, 添加: `alias rm="trash-put $1"`
2. 恢复系统等意外情况出现权限不允许时: 在根目录创建 `/.Trash`, 权限660, 且设置t权限. `chmod a+rw /.Trash;chmod +t /.Trash;`

#### 设备管理简介
1. arch 使用udev作为设备管理器, 负责所有的硬件添加/删除/加载事件.
    - [参考: udev_arch_doc](https://wiki.archlinux.org/index.php/Udev_)
2. 使用 xev 获取键盘键值

#### 亮度调节
tp-x1 的亮度调节文件是 `/sys/class/backlight/intel_backlight/brightness`. 直接重写数值, 就可以改变亮度.

使用快捷键调节亮度时:
1. 调整 `/sys/class/backlight/intel_backlight/brightness` 权限: 默认情况下该文件只有root才能打开.
    - 调整文件所属组为 video: `sudo chgrp video /sys/class/backlight/intel_backlight/brightness`
    - 调整组权限: `sudo chmod  664 /sys/class/backlight/intel_backlight/brightness`
2. 添加用户到组: `sudo usermod -a -G video wzs`
3. 添加脚本到系统路径: [backlight](./config/backlight.sh)
    - 也可以安装 lux, 效果一样.
4. 添加i3快捷键绑定:
    - 使用 `xev` 获取键值
    - 在i3配置文件中添加绑定: `bindsym XF86MonBrightnessDown exec --no-startup-id backlight -dec 100`
5. 官方写的根据 `udev-rules` 也可以更改权限, 但是我试了下失败了.. 权限没有更改成功(文件组没有变化). 流程如下
    - 添加 `.rules` 规则: `vim /etc/udev/rules.d/99-backlight.rules`
    ````
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ````
    - 执行 `udevadm test /sys/class/backlight/intel_backlight/` 测试rules加载

#### 声卡配置
- [参考: 高级 Linux 声音体系](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture_)

开启声音并设置快捷键
1. 启动声音
    - 安装工具包: `sudo pacman -S alas-util` (alsa 默认已经安装, alas-util包含alsamixer)
    - 用户加入 audio 组: `sudo usermod -a -G audio wzs`  或 `sudo gpasswd -a wzs audio`
    - 进入 `alsamixer` 调节配置
    - 测试是否有声音 `speaker-test -c 8`
2. [快捷键配置_i3](./config/i3/config)
    ```Bash
    # 静音
    bindsym XF86AudioMute exec --no-startup-id amixer set Master toggle
    bindsym XF86AudioRaiseVolume exec --no-startup-id amixer set Master 5%+
    bindsym XF86AudioLowerVolume exec --no-startup-id amixer set Master 5%-
    ```
3. [状态栏显示_polybar](./config/polybar/config): 查找alsa 模块

1. 使用 alsamixer 管理声音输出(在 alas-util 包中)
    - 使用介绍: `m`切换静音/非静音
    - f6 切换声卡, 其他参考软件界面说明
    - esc 退出
2. 测试输出声音: `speaker-test -c 8`
    - `-c 8` 表示7.1声道

#### 蓝牙设置
安装 `blueman`, 即可使用 `blueman-manager` 启动蓝牙桌面管理程序. 支持蓝牙耳机, 不用折腾而且还好用的软件

#### Trackpoint
Thinkpad 小红点配置
1. 使用 `xinput` 查看/管理设备
    ```Bash
    xinput list | grep TrackPoint
    xinput list-props _id_
    xinput set-prop _id_ _id_ 0.25
    ```
2. 参考: [小红点配置](https://www.jianshu.com/p/b9677e9e56ec)

#### ossutil设置
阿里云OSS同步工具, 已经在 自动化脚本中 安装&配置 过
1. [文档](https://help.aliyun.com/document_detail/50452.html)
2. oss 配置信息(bucket与密码等): `ossutil config`
