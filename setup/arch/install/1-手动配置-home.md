# arch 日常使用
当将arch作为主力机器, 日常使用时, 需要安装的软件. 与之相对应的是, arch作为服务器使用时的配置.

## 中文支持
首次安装参考 [Linux中文支持](/soft/chinese.md).

重装恢复简易流程如下
```Bash
sudo vim /etc/locale.gen
# 取消 `zh_CN.UTF-8 UTF-8` 和 `en_US.UTF-8 UTF-8` 前的注释
sudo locale-gen
ln -s ~/cloud/backup/config/xinitrc ~/.xinitrc

sudo pacman -S fcitx-im
# arch 下安装搜狗输入法太麻烦了, 推荐安装 google输入法
sudo pacman -S fcitx-googlepinyin
# yay -S fcitx-sogoupinyin

# 然后在 `.config/fcitx/profile` 中启用相应的拼音输入法, 需要修改字体大小则更改 `/usr/share/fcitx/skin/` 相应主题下的文件
ln -s ~/cloud/backup/config/xprofile ~/.xprofile
```

## 字体配置
在 2k14寸/4k27寸 屏幕下
1. termite终端: Inconsolata 字号:27
2. vscode: Lucida Console, 字号默认, 放大4倍.
3. chrome: 175% 缩放
  - standard: Lucida Console
  - sans: Lucida Grande
4. 备用: 中文等宽字体 wqy-microhei

### 桌面配置
参考 [Linux_GUI_i3wm](/soft/gui.md#i3)

### 电源管理
首次安装参考 [电源管理](/soft/power-manger.md)

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
首次安装参考 [硬件配置](/soft/hardware.md)

亮度调节 简易流程如下
```Bash
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod 664 /sys/class/backlight/intel_backlight/brightness
sudo usermod -a -G video wzs
# 将 /soft/script/backlight.sh 添加到 $PATH
# 恢复 i3 配置文件. 其中包含快捷键映射
vim /etc/udev/rules.d/99-backlight.rules
# ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
# active after reboot
```

### 其他软件配置

**shadowsocks**
```Bash
# after copy shadowsocks config
sudo systemctl enable shadowsocks@shadowsocks
sudo systemctl start shadowsocks@shadowsocks
```

**chrome**

chrome 首次登录下载 SwitchOmega 需要翻墙, 因为我使用 ss 搭的梯子, 基于ss这里有两种办法
1. 设置Socket环境变量, 然后在当前shell打开chrome, 此时chrome可以通过ss翻墙. `chromium --proxy-server=socks5://127.0.0.1:1080`
2. 设置http_proxy环境变量, 通过HTTP代理翻墙. HTTP 代理可通过 Provixy 实现(Provixy可以将socket代理转为http代理). 此处不再详述

## 链接
1. [arch_推荐软件](https://wiki.archlinux.org/index.php/General_recommendations_)
2. [arch_常用软件列表](https://wiki.archlinux.org/index.php/General_recommendations_)
