<!-- TOC -->

- [Arch Linux 配置](#arch-linux-配置)
    - [前置配置](#前置配置)
        - [配置网络](#配置网络)
        - [配置用户](#配置用户)
    - [推荐配置](#推荐配置)
        - [电源管理](#电源管理)
            - [休眠支持](#休眠支持)
            - [DPMS](#dpms)
        - [系统备份](#系统备份)
        - [多显示器配置](#多显示器配置)
        - [时间同步](#时间同步)
        - [回收站](#回收站)
        - [ossutil设置](#ossutil设置)
    - [硬件设备管理](#硬件设备管理)
        - [声卡配置](#声卡配置)
        - [蓝牙设置](#蓝牙设置)
    - [笔记本配置](#笔记本配置)
        - [亮度调节](#亮度调节)
        - [Trackpoint](#trackpoint)

<!-- /TOC -->
# Arch Linux 配置

## 前置配置
### 配置网络
如果在安装系统时预先安装了 `wpa_supplicant`, 并且拷贝了网络配置文件, 则直接 `netctl start/stop/status/enable profile` 就可以启动链接.
- profile 只是文件名称, 不含路径
- 如果没有拷贝文件, 那么可以使用 `wifi-menu` 重新建立链接配置
- 如果没有安装 `wpa_supplicant`.  那么只能 要么插网线, 要么使用U盘启动系统, 安装相应软件.

安装`wpa_actiond`以自动切换wifi链接:
1. `sudo systemctl start netctl-auto@wlp4s0.service && sudo systemctl enable netctl-auto@wlp4s0.service`
2. 其中的 `wlp4s0` 改为自己的无线网卡名

也可以通过配置文件管理网络. 具体参考: [静态IP配置](/develop/static-ip.md)
- arch 配置文件可以参考 `/etc/netctl/example/` 下的示例

### 配置用户
添加用户: `useradd -m -g users -G wheel wzs`: 将 `wzs` 换为你的名字
- 修改密码:`passwd wzs`
- users 是所有普通用户的集合(相较与如docker等用户而言). 也被称为 staff 组
- wheel 是一个特殊组, 包含root权限

## 推荐配置

arch 官方推荐列表
- [arch_推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
- [arch_常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)

建议先看下官方教程, 然后根据自己的需求写一个自己的自动化配置脚本. 如下是我的 [配置脚本](./config.sh): 包括vim/ssh/nmap等基础工具, 也有 ss,docker,pip 等软件与配置.
- 执行脚本: `curl -sSL https://raw.githubusercontent.com/everywan/soft/master/os/arch/config.sh | sh -`
- 有兴趣的同学可以使用 export/awk/sed/Python 等实现更多的自动化配置.

我写的配置脚本比较简单, 没有做到全自动化. 需要手动配置的部分如下
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
2. 更改默认shell命令: `chsh`
3. 一指定目录为默认目录: `chroot`
4. tlp(电源管理软件) 采用默认配置即可
    - [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)

### 电源管理
> 参考 [电源管理](https://wiki.archlinux.org/index.php/Power_management_(简体中文))

术语
1. suspend: 挂起到内存, 类似与 windows 的睡眠.
2. hibernate: 休眠, 将内存中的数据dump到disk, 断电后仍可以恢复.
3. hybrid-sleep: 混合睡眠, 同时执行睡眠和休眠: 断电时从disk回复, 未断电从内存恢复. 其他还有延迟休眠等.

#### 休眠支持
> 参考: [Suspend and hibernate](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate_(简体中文))

术语介绍
1. `/sys/power/image_size`: image_size 用于控制将内存 dump 到硬盘时所占空间的大小, 在dump内存时, 系统尽量保证所占用的硬盘空间不会超过image_size设置的大小(dump内存到disk时会压缩数据). 默认是内存的2/5, 增大该值将提升休眠速度, 减小该值将减少空间占用
    - 参考 [swap_partition](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#About_swap_partition.2Ffile_size)

启用休眠支持
1. 创建 swap 分区: 休眠需要将内存中的内容写入swap分区, 建议大小与内存大小相同, 或与所使用的内存大小相同. (swap分区创建参照 arch安装文档)
2. (可选)修改 `/sys/power/image_size` 为swap大小. (这里我设置的是32G)
    - `sudo tee /etc/tmpfiles.d/modify_power_image_size.conf <<< "w /sys/power/image_size - - - - 34359734272`
3. 在bootloader中添加resume参数: 参考 _Suspend and hibernate_
    ```Bash
    vim /etc/default/grub
    # 示例
    GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable"  ==> GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable resume=/dev/sda3"
    # 更新 grub 配置
    grub-mkconfig -o /boot/grub/grub.cfg
    
    vim /etc/mkinitcpio.conf
    # 示例
    HOOKS="base udev autodetect modconf block filesystems keyboard fsck" ==> HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"
    # 重新生成 initramfs 镜像
    mkinitcpio -p linux
    ``

其他参考
- [Archlinux休眠设置](https://www.cnblogs.com/xiaozhang9/p/6443478.html)

#### DPMS
> 参考 [Display_Power_Management_Signaling](https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling_(简体中文))

DPMS 可以在计算机一定时间无操作时, 锁定/休眠计算机 或 将显示器置于节电模式. 配置文件为 `/etc/systemd/logind.conf`, 可通过 `man logind.conf` 查看具体信息.
- 使配置生效: `systemctl restart systemd-logind`

### 系统备份
基本的安装配置后, 第一件事肯定是要先备份下系统, 然后就可以乱搞了...

使用 rsync 备份文件, 使用 acl 备份权限, 使用 tar 压缩备份, 使用 ossutil 上传备份到oss.
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

### 多显示器配置
> 参考 [xrandr_arch_doc](https://wiki.archlinux.org/index.php/Xrandr_)

xrandr 是 X window 下管理多显示器的工具. 使用xrandr管理多显示器输出.
1. 安装: `sudo pacman -S xorg-xrandr`
2. 常用命令与示例
    ```Bash
    xrandr                  # 显示所有可用的显示器
    # 输出图像到 HDMI-2 所连接的显示器, 分辨率自适应, 显示在 eDP-1 显示器的左边
    xrandr --output HDMI-2 --auto --left-of eDP-1
    # 关闭 HDMI-2 连接的显示器
    xrandr --output HDMI-2 --off
    ```

### 时间同步
使用 systemd-timesyncd 进行时间同步. _systemd-timesyncd 是一个用于跨网络同步系统时钟的守护服务_.
1. [参考: systemd-timesyncd_arch](https://wiki.archlinux.org/index.php/Systemd-timesyncd_)
2. 启动 systemd-timesyncd, 设置自动同步: `sudo timedatectl set-ntp true`
2. 配置时间同步服务器: `/etc/systemd/timesyncd.conf`
    ````
    [Time]
    NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
    FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
    ````

### 回收站
arch 默认没有回收站功能, 删除会直接 rm 掉, 偶尔让你变得很难受. 所以使用 `trash-cli` 实现回收站功能
1. 设置 rm 为移动到到回收站: `vim ~/.zshrc`, 添加: `alias rm="trash-put $1"`
2. 恢复系统等意外情况出现权限不允许时: 在根目录创建 `/.Trash`, 权限660, 且设置t权限. `chmod a+rw /.Trash;chmod +t /.Trash;`

### ossutil设置
阿里云OSS同步工具, 已经在 自动化脚本中 安装&配置 过
1. [文档](https://help.aliyun.com/document_detail/50452.html)
2. oss 配置信息(bucket与密码等): `ossutil config`


## 硬件设备管理

工具简介
1. udev: arch 下的设备管理器, 负责所有的硬件添加/删除/加载事件.
    - 参考: [udev](https://wiki.archlinux.org/index.php/Udev_(简体中文))
2. xev: xorg下用于获取按键ID.
    - 参考: [Extra_keyboard_keys](https://wiki.archlinux.org/index.php/Extra_keyboard_keys_(简体中文))

### 声卡配置
- [参考: 高级 Linux 声音体系](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture_)

开启声音并设置快捷键
1. 启动声音
    - 安装工具包: `sudo pacman -S alsa-utils` (alsa 默认已经安装, alas-util包含alsamixer)
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

### 蓝牙设置
安装 `blueman`, 即可使用 `blueman-manager` 启动蓝牙桌面管理程序. 支持蓝牙耳机, 不用折腾而且还好用的软件



## 笔记本配置

### 亮度调节
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

### Trackpoint
Thinkpad 小红点配置
1. 使用 `xinput` 查看/管理设备
    ```Bash
    xinput list | grep TrackPoint
    xinput list-props _id_
    xinput set-prop _id_ _id_ 0.25
    ```
2. 参考: [小红点配置](https://www.jianshu.com/p/b9677e9e56ec)
