- [Arch Linux 配置](#arch-linux-%E9%85%8D%E7%BD%AE)
  - [必备软件](#%E5%BF%85%E5%A4%87%E8%BD%AF%E4%BB%B6)
    - [网络](#%E7%BD%91%E7%BB%9C)
    - [用户](#%E7%94%A8%E6%88%B7)
    - [必备软件安装脚本](#%E5%BF%85%E5%A4%87%E8%BD%AF%E4%BB%B6%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%AC)
    - [桌面环境安装](#%E6%A1%8C%E9%9D%A2%E7%8E%AF%E5%A2%83%E5%AE%89%E8%A3%85)
    - [中文支持](#%E4%B8%AD%E6%96%87%E6%94%AF%E6%8C%81)
      - [字体](#%E5%AD%97%E4%BD%93)
      - [输入法](#%E8%BE%93%E5%85%A5%E6%B3%95)
    - [时间同步](#%E6%97%B6%E9%97%B4%E5%90%8C%E6%AD%A5)
    - [电源管理](#%E7%94%B5%E6%BA%90%E7%AE%A1%E7%90%86)
      - [休眠支持](#%E4%BC%91%E7%9C%A0%E6%94%AF%E6%8C%81)
      - [DPMS](#dpms)
  - [硬件配置](#%E7%A1%AC%E4%BB%B6%E9%85%8D%E7%BD%AE)
    - [独立显卡](#%E7%8B%AC%E7%AB%8B%E6%98%BE%E5%8D%A1)
    - [声卡配置](#%E5%A3%B0%E5%8D%A1%E9%85%8D%E7%BD%AE)
    - [蓝牙设置](#%E8%93%9D%E7%89%99%E8%AE%BE%E7%BD%AE)
    - [亮度调节](#%E4%BA%AE%E5%BA%A6%E8%B0%83%E8%8A%82)
    - [Trackpoint](#trackpoint)
  - [推荐软件](#%E6%8E%A8%E8%8D%90%E8%BD%AF%E4%BB%B6)
    - [chrome](#chrome)
    - [回收站](#%E5%9B%9E%E6%94%B6%E7%AB%99)
    - [内网穿透](#%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F)
    - [ossutil设置](#ossutil%E8%AE%BE%E7%BD%AE)
    - [系统备份](#%E7%B3%BB%E7%BB%9F%E5%A4%87%E4%BB%BD)
  - [问题](#%E9%97%AE%E9%A2%98)

# Arch Linux 配置
配置流程如下
1. 首先配置网络, 添加个人用户.
2. 安装zsh等必备软件
3. 配置桌面环境, 中文输入法等中文支持(方便联网排查问题, 复制粘贴命令等)
4. 针对不同的硬件, 进行不同的配置
5. 修改软件配置
6. 遇到需要的软件再去安装, 切忌妄想一步登天.

一般而言, 我喜欢讲配置文件等备份到 oss 上, 所以我需要更早的安装 ossutil, 并且将文件拷贝下来. oss下载脚本如下
1. 脚本: `/usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur oss://cloud-cn/arch ./cloud`

## 必备软件
### 网络
如果在安装系统时预先安装了 `wpa_supplicant`, 并且拷贝了网络配置文件, 则直接 `netctl start/stop/status/enable profile` 就可以启动链接.
- profile 只是文件名称, 不含路径
- 如果没有拷贝文件, 那么可以使用 `wifi-menu` 重新建立链接配置
- 如果没有安装 `wpa_supplicant`.  那么只能 要么插网线, 要么使用U盘启动系统, 安装相应软件.

安装`wpa_actiond`以自动切换wifi链接:
1. `sudo systemctl start netctl-auto@wlp4s0.service && sudo systemctl enable netctl-auto@wlp4s0.service`
2. 其中的 `wlp4s0` 改为自己的无线网卡名

也可以通过配置文件管理网络. 具体参考: [静态IP配置](/develop/static-ip.md)
- arch 配置文件可以参考 `/etc/netctl/example/` 下的示例

### 用户
添加用户: `useradd -m -g users -G wheel wzs`: 将 `wzs` 换为你的名字
1. 修改密码:`passwd wzs`
2. users 是所有普通用户的集合(相较与如docker等用户而言). 也被称为 staff 组
3. wheel 是一个特殊组, 包含root权限

### 必备软件安装脚本
1. 执行脚本: `curl -sSL https://raw.githubusercontent.com/everywan/soft/master/os/arch/config.sh | sh -`
    - 由于脚本没有进行容错处理, 所以
2. 有兴趣的同学可以使用 export/awk/sed/Python 等实现更多的自动化配置.

我写的配置脚本比较简单, 没有做到全自动化. 需要手动配置的部分如下
1. zsh配置
    - 主题修改为ys: `vim ~/.zshrc` 修改 `ZSH_THEME="ys"`
    - use zsh like vim: `bindkey -v`
2. 更改默认shell命令: `chsh`
3. 指定目录为默认目录: `chroot`
4. tlp(电源管理软件) 采用默认配置即可
    - [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)

### 桌面环境安装
### 中文支持
> 参考 [中文支持](https://wiki.archlinux.org/index.php/Localization/Simplified_Chinese_(简体中文))

术语介绍
1. .xinitrc is run by xinit (and therefore also startx). In addition to configuration, it is also responsible for starting the root X program (usually a window manager such as Gnome, KDE, i3, etc.). This usually applies when X is started manually by the user (with starx or similar).
2. .xsession is similar to .xinitrc but is used by display managers (such as lightdm, or sddm) when a user logs in. However, with modern DMs the user can usually choose a window manager to start, and the DM may or may not run the .xsession file.
3. .xprofile is just for setting up the environment when logging in with an X session (usually via a display manager). It is similar to your .profile file, but specific to x sessions.

启用arch的中文支持: 设置正确的locale并安装合适的中文字体. 流程如下
1. 安装中文 locale
    1. `vim /etc/locale.gen`, 取消 `zh_CN.UTF-8 UTF-8` 和 `en_US.UTF-8 UTF-8` 前的注释.
    2. 执行 `locale-gen`, 使系统应用更改.
2. 启用中文 locale: 根据如下作用域, 在不同的文件添加 `LANG=en_US.UTF-8`
    - `/etc/locale.conf`: 全局 locale. (不推荐使用全局中文, 会导致tty乱码)
    - `.bashrc`: 终端启动时.
    - `.xinitrc`: 使用 xinit/startx 等启动x时.
    - `.xprofile`: 登录管理器启动时.
3. 图形界面启用中文: 在 `.xinitrc` 和 `.xprofile` 添加如下内容, 两个文件的区别见上述.
    ```Bash
    # 在 .xinitrc 文件中, 将此内容放到 exec _example_WM_or_DE_ 之前
    export LANG=zh_CN.UTF-8
    export LANGUAGE=zh_CN:en_US
    export LC_CTYPE=en_US.UTF-8
    # 仅 .xprofile 文件支持
    export LC_ALL="zh_CN.UTF-8"
    ```

参考
1. [xprofile-vs-xsession-vs-xinitrc](https://stackoverflow.com/questions/41397361/xprofile-vs-xsession-vs-xinitrc)

#### 字体
- 基础中文字体: `sudo pacman -S wqy-microhei`
- 网评最佳编程字体: `sudo pacman -S ttf-inconsolata`
- Mac字体: `sudo pacman -S ttf-inconsolata`
- emoji字体: `sudo pacman -S ttf-font-awesome`
    - [官方网站](https://fontawesome.com/icons?d=gallery)

常用命令
```Bash
# 查看已安装的字体(默认 /usr/share/fonts)
fc-list
# 刷新字体缓存
fc-cache -vf
```

#### 输入法
> 参考 [fcitx](https://wiki.archlinux.org/index.php/Fcitx_(简体中文))

fcitx 是 Linux 下最常用的输入法. 配置流程如下
1. 安装: `sudo pacman -S fcitx`. 优先推荐搜狗输入法: `yay -S fcitx-sogoupinyin`.
   1. 同时安装 `sudo pacman -S fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5`, 否则某些拼音的面板不能显示.
   2. 同时需要在 `.config/fcitx/profile` 中启用相应的拼音输入法
2. 创建 .xprofile, 设置桌面环境下的环境变量
    ```Bash
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    ```
3. 在 xinitrc 中加载 xprofile, 并且启动 fcitx
    ```Bash
    [ -f /etc/xprofile ] && source /etc/xprofile
    [ -f ~/.xprofile ] && source ~/.xprofile
    fcitx -r &
    ```
4. 修改 fcitx 配置
    - 配置文件路径: `~/.config/fcitx/`, `/usr/share/fcitx`
    - 注意在退出fcitx的情况下修改配置, 否则配置可能被覆盖.

用法
- 剪切板: `Ctrl + ;`

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

其他参考
- [Archlinux休眠设置](https://www.cnblogs.com/xiaozhang9/p/6443478.html)

#### DPMS
> 参考 [Display_Power_Management_Signaling](https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling_(简体中文))

DPMS 可以在计算机一定时间无操作时, 锁定/休眠计算机 或 将显示器置于节电模式. 配置文件为 `/etc/systemd/logind.conf`, 可通过 `man logind.conf` 查看具体信息.
- 使配置生效: `systemctl restart systemd-logind`

## 硬件配置
> 注: 机器为ThinkPad. 其他机器请稍加注意.

工具简介
1. udev: arch 下的设备管理器, 负责所有的硬件添加/删除/加载事件.
    - 参考: [udev](https://wiki.archlinux.org/index.php/Udev_(简体中文))
2. xev: xorg下用于获取按键ID.
    - 参考: [Extra_keyboard_keys](https://wiki.archlinux.org/index.php/Extra_keyboard_keys_(简体中文))

### 独立显卡
特指Nvidia显卡, 以MX150为例. 此处使用 Bumblebee.

1. 安装 nvidia 驱动: `sudo pacman -S nvidia`
2. 安装 bumblebee: `sudo pacman -S bumblebee mesa`
3. 添加到用户组: `sudo gpasswd -a user bumblebee`
4. 启用 bumblebee 服务: `sudo systemctl enable bumblebeed.service`
5. 重启系统

测试
1. 测试独立显卡是否工作: 执行 `nvidia-smi`, 如果输出信息 则证明独立显卡正常
2. 测试 bumblebee
   1. 安装 `sudo pacman -S mesa-demos`
   2. 执行 `optirun glxgears -info`, 如无反应, 则执行 `optirun glxspheres64` (64位系统), 如果出现动画窗口, 则说明 Optimus 和 Bumblebee 正在工作.

参考文章
1. [NVIDIA Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_)
2. [Nvidia 驱动](https://wiki.archlinux.org/index.php/NVIDIA_)
3. [Bumblebee](https://wiki.archlinux.org/index.php/Bumblebee_)

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

4. 使用 alsamixer 管理声音输出(在 alas-util 包中)
    - 使用介绍: `m`切换静音/非静音
    - f6 切换声卡, 其他参考软件界面说明
    - esc 退出
5. 测试输出声音: `speaker-test -c 8`
    - `-c 8` 表示7.1声道

### 蓝牙设置
安装 `blueman`, 即可使用 `blueman-manager` 启动蓝牙桌面管理程序. 支持蓝牙耳机, 不用折腾而且还好用的软件

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
5. 官方写的根据 `udev-rules` 更改组权限(需重启)
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

## 推荐软件
arch 官方推荐列表
- [arch_推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
- [arch_常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)

### chrome
chrome 首次登录下载 SwitchOmega 需要翻墙, 因为我使用 ss 搭的梯子, 基于ss这里有两种办法
1. 设置Socket环境变量, 然后在当前shell打开chrome, 此时chrome可以通过ss翻墙.
   1. 设置socket版本: `export SOCKS_VERSION=5`
   2. 设置socket服务器: `export SOCKS_SERVER="http://127.0.0.1:1080"`
2. 设置http_proxy环境变量, 通过HTTP代理翻墙. HTTP 代理可通过 Provixy 实现(Provixy可以将socket代理转为http代理). 此处不再详述

### 回收站
arch 默认没有回收站功能, 删除会直接 rm 掉, 偶尔让你变得很难受. 所以使用 `trash-cli` 实现回收站功能
1. 设置 rm 为移动到到回收站: `vim ~/.zshrc`, 添加: `alias rm="trash-put $1"`
2. 恢复系统等意外情况出现权限不允许时: 在根目录创建 `/.Trash`, 权限660, 且设置t权限. `chmod a+rw /.Trash;chmod +t /.Trash;`

### 内网穿透
使用frp软件进行内网穿透, 配置参考官网 [frp](https://github.com/fatedier/frp/blob/master/README.md).

frp 可以通过编写脚本实现由 systemd 管理, 脚本编写方式参考 [systemd](/develop/systemd.md#systemd脚本), 脚本参考 [frpc](./script/frpc.service) [frps](./script/frps.service)

### ossutil设置
阿里云OSS同步工具, 已经在 自动化脚本中 安装&配置 过
1. [文档](https://help.aliyun.com/document_detail/50452.html)
2. oss 配置信息(bucket与密码等): `ossutil config`

### 系统备份
基本的安装配置后, 第一件事肯定是要先备份下系统, 然后就可以乱搞了...

使用 rsync 备份文件, 使用 acl 备份权限, 使用 tar 压缩备份, 使用 ossutil 上传备份到oss.
```Bash
# 备份系统, 恢复系统只需要换下 文件夹顺序就行了 
rsync -arpogv /* /backup/backup --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/backup/*}
# 备份权限(需要先安装 acl)
getfacl -R / > /backup/backup_permissions.txt
# 压缩备份
tar -jcvf /backup/backup.tar.bz2 /backup/backup /backup/backup_permissions.txt
# 恢复权限
# setfacl --restore=backup_permissions.txt
```

## 问题
1. fcitx 输入法出现漏字: 输入拼音时, 字母直接出现在输入框.
    - 问题复现: 输入 `窗口管理器` 可以测试
    - 修复: 重新安装 `fcitx-im`, 并且重启系统