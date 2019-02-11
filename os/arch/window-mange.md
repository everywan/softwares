- [桌面环境配置](#%E6%A1%8C%E9%9D%A2%E7%8E%AF%E5%A2%83%E9%85%8D%E7%BD%AE)
  - [窗口协议与术语介绍](#%E7%AA%97%E5%8F%A3%E5%8D%8F%E8%AE%AE%E4%B8%8E%E6%9C%AF%E8%AF%AD%E4%BB%8B%E7%BB%8D)
  - [窗口管理器比较](#%E7%AA%97%E5%8F%A3%E7%AE%A1%E7%90%86%E5%99%A8%E6%AF%94%E8%BE%83)
  - [i3wm](#i3wm)
    - [安装](#%E5%AE%89%E8%A3%85)
    - [安装合成器](#%E5%AE%89%E8%A3%85%E5%90%88%E6%88%90%E5%99%A8)
    - [启动与配置](#%E5%90%AF%E5%8A%A8%E4%B8%8E%E9%85%8D%E7%BD%AE)
  - [polybar](#polybar)
  - [显示器](#%E6%98%BE%E7%A4%BA%E5%99%A8)
    - [HDPI](#hdpi)
    - [多显示器配置](#%E5%A4%9A%E6%98%BE%E7%A4%BA%E5%99%A8%E9%85%8D%E7%BD%AE)

# 桌面环境配置

arch 默认没有图形界面, 如果需要安装图形界面可以参考如下教程. (前半部分介绍了桌面环境的一些基本现状, 不感兴趣的可以直接跳过).

所使用的桌面环境如下

| 部件    | 软件      | 介绍                                           |
|-------|---------|----------------------------------------------|
| 窗口管理器 | i3wm    | 平铺式桌面, 可配置度高, 与windows/osx桌面环境的使用方式不同, 需要适应期 |
| 锁屏软件  | i3lock  |                                              |
| 状态栏   | polybar |                                              |

## 窗口协议与术语介绍
目前常用的窗口协议有 x window system 与 wayland. x window system 是目前较为流行且广泛支持的协议标准, wayland 是为了取代 x 而提出的新标准, 与 x 不兼容, GUI应用需要支持 wayland 协议才能正常显示. 需要注意的是, x 与 wayland 都只是协议, 并不是具体的软件. x协议在linux下的实现被称为 x.org, wayland 的实现被称为 wayland compositer.

两者的架构区别详情见链接 [Wayland Architecture](https://wayland.freedesktop.org/architecture.html), 图示如下.

![x-architecture](./attach/x-architecture.png) ![wayland-architecture](./attach/wayland-architecture.png)

术语介绍:
1. 窗口管理器: 管理窗口, 如窗口的显示/隐藏, 前后/大小等 的程序, 窗口管理器与Xserver直接进行交互(Xorg是服务端, C/S结构).
2. 显示管理器: 管理登录界面. 可以理解为 windows 的锁屏解锁界面.
3. 桌面环境: 桌面环境是一个整体的环境, 是一系列桌面软件的集合, 包括窗口管理器, 登录管理器, 一系列桌面程序等. 如 Gnome/KDE 都是桌面环境

参考
1. [桌面管理器vs窗口管理器](https://my.oschina.net/aspirs/blog/607710)
2. [xorg](https://wiki.archlinux.org/index.php/Xorg_(简体中文))

## 窗口管理器比较
> 参考: [窗口管理器](https://wiki.archlinux.org/index.php/Window_manager_(简体中文))

个人比较推荐平铺式管理器.

在平铺式管理器中, 使用比较多的有 i3/sway/dwm/awesome/xmoad. 简介如下
1. dwm 最为精简, 不过每次修改配置都需要该源码(源码只有两千多行, 很精简)
2. xmoad 使用 haskell 语言开发, 如果你熟悉该语言可以尝试此版本.
3. awesome 使用 lua 作为配置语言.
4. sway 是 i3 的 wayland 版.

其实这几个软件大体上差别并不大, 关于这个我没有特别的建议(因为我也没用过), 有兴趣的同学可以自己逐个尝试下.

## i3wm
> 参考: [i3_arch](https://wiki.archlinux.org/index.php/I3_(简体中文))   
> 

### 安装
```Bash
# feh: 图片查看工具, 用于设置壁纸;  rofi: app启动器, i3lock: 锁屏
sudo pacman -S xorg xorg-xinit termite feh rofi
sudo pacman -S scrot i3lock imagemagick
cp /etc/X11/xinit/xinitrc ~/.xinitrc
yay -S i3
```

### 安装合成器
> 参考: [Compton](https://wiki.archlinux.org/index.php/Compton_(简体中文))

i3 自身不带半透明, 淡入淡出等特效, 需要安装独立的 compositor(合成器). 
- termite 设置透明度无效就是因为没有 compositor 导致的.
- compton 是一个独立的合成管理器, 可以用来给i3添加各种视觉效果(半透明, 淡入淡出).

使用 compton 作为 i3 的合成器:
1. 安装: `pacman -S compton`
2. 随桌面启动: `vim ~/.xinitrc`, 添加 `exec compton -b &`

问题解决
- 当使用 `nvidia-340xx-utils` 驱动时, 启动 compton 可能报错. 更换驱动为 libglvnd 即可解决.
    - 如果卸载 nvidia-xx 后, 启动 startx 报错, 重新安装 xorg 即可解决: `pacman -S xorg`

### 启动与配置

通过修改 xinitrc 即可在启动 xserver 时启动i3. xserver 可通过 startx 启动
1. 修改 .xinitrc, 添加 `exec i3`.
    - 注意, 在 xinitrc 中只有第一个 exec 会生效, 之后的exec不会被执行. [详细](https://wiki.archlinux.org/index.php/Xinit#xinitrc)
    - 如果需要 i3 输出日志, 替换启动语句如下: `exec i3 -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1`

i3配置: 配置方法参考 [官方文档](https://i3wm.org/docs/userguide.html), 快捷键方案参考 [快捷键方案](/search/shortcut.md)
1. 配置文件位置: `~/.config/i3/config`
2. 工具
    - 使用 `xprop` 可以查看窗口的class. (具体用法: 在浮动等非覆盖布局下, 输入 xprop, 然后点击窗口)

术语介绍
1. scratchpad: 临时窗口存储区, 可以方便的隐藏/调出, 悬浮在所有窗口之上. 类似于 guake, 不过 guake 在上方显示, scraptch 可调.

## polybar
> [官方文档](https://github.com/jaagr/polybar/wiki)

使用polybar纯粹是网上看的别人的教程, 具体与 i3-bar 的区别有兴趣的同学可以自己尝试下.
1. 安装: `yay -S polybar`
2. 启动: 编写 polybar 启动脚本, 然后将脚本挂载到 i3 配置文件中, 实现随i3启动.
    - [polybar启动脚本示例](./config/polybar/launch.sh)
    - 随i3启动: 在 `~/.config/i3/config` 文件最后添加: `exec_always --no-startup-id $HOME/.config/polybar/launch.sh`, 并注释掉 i3-bar
3. 配置: 参考官方文档
    - 特殊符号可查看所安装的 emoji 字体的支持的符号.

## 显示器
### HDPI
直接在相关软件里设置字体大小即可. 不建议使用 xrandr 的缩放, 因为缩放会失去 HDPI 本身的意义.
- 使用xrandr缩放 (不建议): `xrandr --output DP-1 --scale 0.5x0.5`

4k/27寸 建议 20/25 字体大小

相关配置路径
1. fcitx 字体配置
    - `vim /usr/share/fcitx/skin/classic/fcitx_skin.conf`, 字体 25 即可

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