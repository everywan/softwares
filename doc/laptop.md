# 笔记本配置
以下以 Thinkpad 为例.

工具
1. udev: arch 下的设备管理器, 负责所有的硬件添加/删除/加载事件.
    - 参考: [udev](https://wiki.archlinux.org/index.php/Udev_(简体中文))
2. xev: xorg下用于获取按键ID.
    - 参考: [Extra_keyboard_keys](https://wiki.archlinux.org/index.php/Extra_keyboard_keys_(简体中文))

## 主板
UEFI: (Unified Extensible Firmware Interface) 统一的可扩展固定接口, 新一代的BIOS标准. 当PC启动时, 首先运行 UEFI BIOS, 然后载入操作系统.

Secure Boot: Secure Boot 就是 UEFI 的一部分, 用于防止恶意软件侵入, 通过密钥加密实现. UEFI规定, 主板出场时, 必须内置一些可靠的公钥, 然后, 任何想要在这块主板上加载的操作系统或硬件驱动程序都必须经过公钥的认证, 及这些软件都必须被对应的私钥签署过


## 声卡配置
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
3. [状态栏显示_polybar](./config/polybar/config): 查找 alsa 模块
4. 使用 alsamixer 管理声音输出(在 alas-util 包中)
    - 使用介绍: `m`切换静音/非静音
    - f6 切换声卡, 其他参考软件界面说明
    - esc 退出
5. 测试输出声音: `speaker-test -c 8`
    - `-c 8` 表示7.1声道

## 亮度调节
tp-x1 的亮度调节文件是 `/sys/class/backlight/intel_backlight/brightness`. 直接重写数值, 就可以改变亮度.

使用快捷键调节亮度时:
1. 调整 `/sys/class/backlight/intel_backlight/brightness` 权限: 默认情况下该文件只有root才能打开.
    - 调整文件所属组为 video: `sudo chgrp video /sys/class/backlight/intel_backlight/brightness`
    - 调整组权限: `sudo chmod  664 /sys/class/backlight/intel_backlight/brightness`
2. 添加用户到组: `sudo usermod -a -G video wzs`
3. 添加脚本到系统路径: [backlight](./script/backlight.sh)
    - 也可以安装 lux, 效果一样.
4. 添加i3快捷键绑定:
    - 使用 `xev` 获取键值
    - 在i3配置文件中添加绑定: `bindsym XF86MonBrightnessDown exec --no-startup-id backlight -dec 100`
5. 官方写的根据 `udev-rules` 更改组权限(需重启)
    - 添加 `.rules` 规则: `vim /etc/udev/rules.d/99-backlight.rules`
    ````
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ````
    - 执行 `udevadm test /sys/class/backlight/intel_backlight/` 测试rules加载

## 电源管理
术语
1. suspend: 挂起到内存, 类似与 windows 的睡眠.
2. hibernate: 休眠, 将内存中的数据dump到disk, 断电后仍可以恢复.
3. hybrid-sleep: 混合睡眠, 同时执行睡眠和休眠: 断电时从disk回复, 未断电从内存恢复. 其他还有延迟休眠等.
4. `/sys/power/image_size`: image_size 用于控制将内存 dump 到硬盘时所占空间的大小, 在dump内存时, 系统尽量保证所占用的硬盘空间不会超过image_size设置的大小(dump内存到disk时会压缩数据). 默认是内存的2/5, 增大该值将提升休眠速度, 减小该值将减少空间占用

### 休眠支持
启用休眠支持教程如下
1. 创建 swap 分区: 休眠需要将内存中的内容写入swap分区, 建议大小与内存大小相同, 或与所使用的内存大小相同. (swap分区创建参照 arch安装文档)
2. (可选)修改 `/sys/power/image_size` 为swap大小. (这里我设置的是32G)
    - `sudo tee /etc/tmpfiles.d/modify_power_image_size.conf <<< "w /sys/power/image_size - - - - 34359734272"`
3. 在bootloader中添加resume参数: 参考 _Suspend and hibernate_
    ```Bash
    vim /etc/default/grub
    # 示例, 注意更换 /dev/sda3 为自己电脑上 交换分区 的位置
    GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable"  ==> GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable resume=/dev/sda3"
    # 更新 grub 配置
    grub-mkconfig -o /boot/grub/grub.cfg
    
    vim /etc/mkinitcpio.conf
    # 示例, 添加了 resume
    HOOKS="base udev autodetect modconf block filesystems keyboard fsck" ==> HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"
    # 重新生成 initramfs 镜像
    mkinitcpio -p linux
    ```

### DPMS
DPMS 可以在计算机一定时间无操作时, 锁定/休眠计算机 或 将显示器置于节电模式. 配置文件为 `/etc/systemd/logind.conf`, 可通过 `man logind.conf` 查看具体信息.
- 使配置生效: `systemctl restart systemd-logind`

## 蓝牙设置
安装 `blueman`, 即可使用 `blueman-manager` 启动蓝牙桌面管理程序. 支持蓝牙耳机, 不用折腾而且还好用的软件

### Trackpoint
Thinkpad 小红点配置
1. 使用 `xinput` 查看/管理设备
    ```Bash
    xinput list | grep TrackPoint
    # 查看指定设备属性
    xinput list-props _id_
    # 设置值
    xinput set-prop _id_ _id_ 0.25
    ```

## 参考
1. [Archlinux休眠设置](https://www.cnblogs.com/xiaozhang9/p/6443478.html)
2. [高级 Linux 声音体系](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture_)
3. [电源管理](https://wiki.archlinux.org/index.php/Power_management_(简体中文))
4. [Suspend and hibernate](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate_(简体中文))
5. [swap_partition](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#About_swap_partition.2Ffile_size)
6. [Display_Power_Management_Signaling](https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling_(简体中文))
7. [小红点配置](https://www.jianshu.com/p/b9677e9e56ec)
