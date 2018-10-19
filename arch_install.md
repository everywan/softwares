# Arch Linux 安装与配置

- [Arch Linux 手册](https://wiki.archlinux.org/index.php/Main_page_(简体中文))
- [Arch Linux的原则](https://wiki.archlinux.org/index.php/Arch_Linux_(简体中文))

## 安装
- [Arch Linux安装教程](https://wiki.archlinux.org/index.php/Installation_guide_(简体中文))

###  准备
1. 刻录U盘安装
    - Linux环境: `dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync`. (注意替换iso路径和U盘路径)
2. 重启电脑, 选择U盘启动
    - Thinkpad: 开机回车, 然后f12进入挂载启动页, 选择刻录的U盘即可.

注意查看是否报错.

### 预配置系统
1. 链接wifi: `wifi-menu`
    - arch 默认网络安装.
2. 使用parted格式化硬盘为GPT分区: 后续使用GRUB/UEFI引导需要
    - [GURB引导](https://wiki.archlinux.org/index.php/GRUB_(简体中文)#UEFI_.E7.B3.BB.E7.BB.9F)
    - [Parted工具](https://wiki.archlinux.org/index.php/GNU_Parted_(简体中文)): parted比fdisk功能更多, 这里主要用来设置硬盘为gpt格式.
3. 分区方案: `fdisk /dev/sda`
    - efi 分区: 521Mb
    - swqp 分区: 实际内存 <2G: 2G; 2G~8G: 内存同大小; >8G:8G.
    - 推荐 `/home, /usr/local/` 单独分区, 一个存放个人资料, 一个存放个人程式
    - `/tmp, /var` 根据需要决定是否单独分区(某些服务器需要单独设置, 避免临时文件填充满整个系统)
    - 剩下的所有可用空间给 `/`
4. 格式化:
    - `mkfs.fat /dev/sda1`: efi分区
    - `mkswap /dev/sda2`: 格式化swap分区;  `swapon/off /dev/sda2`: 挂载/卸载 swap 分区
    - `mkfs.ext4 /dev/sda3`: 格式化其他分区
5. 挂载分区
    - `mount /mnt /dev/sda3`: 挂载 `/` 目录
    - `mkdir /mnt/boot && mount /dev/sda1`: 创建boot目录并挂载 `efi` 分区
    - `mkdir /mnt/home && mount /dev/sda4`: 创建home目录并挂载 `home` 分区
6. 安装基本系统: `pacstrap /mnt base base-devel`
    - `base-devel`: 开发基本工具包
7. 生成并检查 fstab 文件: `genfstab -U /mnt >> /mnt/etc/fstab`
8. 切换到新系统: `arch-chroot /mnt`

部分比较麻烦的设置待系统装完后在设置.

### 配置系统
1. 设置时区并更新时间: `ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock --systohc`
2. 修改主机名: `echo "x1" >> /etc/hostname`
3. **无线网络配置**: 
    - 安装必备软工具: `pacman -S dialog wpa_supplicant`
    - 拷贝无线网配置文件: `mv etc/netctl/xx /mnt/etc/netctl/`. (注意, 这一步应该在 `chroot` 之前完成, 可以 `exit` 退出arch后完成拷贝, 然后再执行 `arch-chroot /mnt`)
4. 设置密码: `passwd`
5. 设置grub引导: `pacman -S grub efibootmgr && grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub && grub-mkconfig -o /boot/grub/grub.cfg`
    - [GURB引导](https://wiki.archlinux.org/index.php/GRUB_(简体中文)#UEFI_.E7.B3.BB.E7.BB.9F)
    - [Parted工具](https://wiki.archlinux.org/index.php/GNU_Parted_(简体中文))
    - 流程解释:
        - 安装工具包:`pacman -S grub efibootmgr`
        - 设置启动目录, 引导程序, 挂载分区:`grub-install --target=x86_64-efi --efi-directory=esp_mount --bootloader-id=grub`. (注意替换必要参数)
        - 生成配置文件: `grub-mkconfig -o /boot/grub/grub.cfg`
6. Intel/AMD CPU启用微码更新
    - Intel: `pacman -S intel-ucode`
7. 退出并系统: `exit && reboot`

## 系统配置
配置网络: 
1. 启用连接: 如果在上述步骤已经安装`wpa_supplicant`并且拷贝了网络配置文件, 直接`netctl start/stop/status/enable profile` 即可启动wifi链接
    - 如果没有拷贝文件, 那么可以使用 `wifi-menu` 重新建立链接配置
    - 如果没有安装 `wpa_supplicant`..  那么只能要么插网线, 要么使用U盘启动系统, 安装相应软件.
    - profile 只是文件名称, 不含路径
2. 添加用户
    - `useradd -m -g users -G wheel wzs`
    - 修改密码:`passwd wzs`

### 软件安装
- [推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
- [常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)
- [安装脚本](./arch_install.sh)

### 软件配置
建议看官方文档, 很全很好.

1. oh-my-zsh:
    - 主题修改为ys: `ZSH_THEME="ys"`
2. 更改默认shell为zsh: `chsh`
3. 笔记本调节声音:  [高级 Linux 声音体系](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture_)
    - 声音输出测试: `# speaker-test -c 2 声音测试`
4. [笔记本设置](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd)
    - 合盖等状态设置: 修改文件` vim /etc/systemd/logind.conf`
    - 使配置生效: `systemctl restart systemd-logind`
5. Thinkpad 小红点配置: 使用 `xinput` 查看.
    - 参考: [小红点](https://www.jianshu.com/p/b9677e9e56ec)
    - 示例如下
    ```Bash
    xinput list | grep TrackPoint
    xinput list-props _id_
    xinput set-prop _id_ _id_ 0.25
    ```
6. ossutil 设置(用于云盘备份)
    - [文档](https://help.aliyun.com/document_detail/50452.html)
    - 设置oss: `./ossutil config`
7. 回收站: `trash-cli`,
    - 设置删除为扔到回收站: 在 `~/.zshrc` 中添加: `alias rm="trash-put $1"`
    - 恢复系统等意外情况出现权限不允许时,  在根目录创建 `/.Trash`, 权限660, 且设置t权限. `chmod a+rw /.Trash;chmod +t /.Trash;`
8. 设置时间: `sudo timedatectl set-ntp true`, 并且修改 `/etc/systemd/timesyncd.conf`
    ````
    [Time]
    NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
    FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
    ````
9. 蓝牙设置

#### 亮度调节与设备管理
arch 使用udev作为设备管理器, 负责所有的硬件添加/删除/加载事件.

tp-x1 的亮度调节文件是 `/sys/class/backlight/intel_backlight/brightness`. 只需要重写数值, 就可以改变亮度.

i3使用快捷键调节亮度时, 需要配置键值映射以及一些其他操作
1. 调整 `/sys/class/backlight/intel_backlight/brightness` 权限: 默认情况下该文件只有root才能打开.
    - 调整文件所属组为 video: `sudo chgrp video /sys/class/backlight/intel_backlight/brightness`
    - 调整组权限: `sudo chmod  664 /sys/class/backlight/intel_backlight/brightness`
2. 添加用户到组: `sudo usermod -a -G video wzs`
3. 添加i3快捷键绑定:
    - 使用 `xev` 获取键值
    - 在i3配置文件中添加绑定
4. 添加脚本到系统路径: [backlight](./backlight.sh)
    - 也可以安装 lux, 效果一样.
5. 官方写的根据 `udev-rules` 也可以更改权限, 但是我试了下失败了.. 权限没有更改成功(文件组没有变化). 流程如下
    - 添加 `.rules` 规则: `vim /etc/udev/rules.d/99-backlight.rules`
    ````
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ````
    - 执行 `udevadm test /sys/class/backlight/intel_backlight/` 测试rules加载

### 备份系统
使用 rsync 备份文件, 使用 acl 备份权限, 使用 tar 压缩备份, 使用 ossutil 上传备份到oss.

```Bash
# rsync -arpogv /* /backup/backup --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/backup/*}
# getfacl -R / > /backup/backup_permissions.txt
# tar -jcvf /backup/backup.tar.bz2 /backup/backup
# setfacl --restore=backup_permissions.txt
```

### 配置桌面环境/中文环境
[参考: arch 桌面环境配置](./arch_wm_config.md).


### polybar配置
- [官方文档](https://github.com/jaagr/polybar/wiki)
- [我的配置文件](./config/polybar/config)
- [特殊符号网站, 用于在状态栏显示图标](http://cn.piliapp.com/symbol/)

### 设置TLP电源管理
- [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)

