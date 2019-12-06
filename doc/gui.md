# Linux桌面环境

Linux 桌面环境一般由如下几部分组成
1. 图形接口协议: 为GUI环境提供基本的框架协议, 包括屏幕绘制, 设备交互, 图像呈现等. 目前有 xwindow 和 wayland.
2. 协议实现: xwindow 的实现为 X.org, wayland 的实现为 wayland compositer.
3. 相应的桌面程序, 主要分为以下三类, 合起来统称为桌面环境.
   1. 窗口管理器: 管理窗口. 控制 窗口的显示/隐藏/顺序/大小等状态 的程序, 在 X 中, 窗口管理器直接与Xserver进行交互.
   2. 锁屏管理器: 锁屏界面. 可以理解为 windows 的锁屏解锁界面.
   3. 登录管理器: 也称显示管理器, 用于启动桌面环境, 然后进行图形界面登录(当不使用登录管理器时, 需要通过 startx/xinit/x 手动启用 Xserver/xclient)

## 图形接口协议
目前常用的窗口协议有 x window system 与 wayland. x window system 是目前较为流行且广泛支持的协议标准, wayland 是为了取代 x 而提出的新标准, 与 x 不兼容, GUI应用需要支持 wayland 协议才能正常显示. 需要注意的是, x 与 wayland 都只是协议, 并不是具体的软件. x协议在linux下的实现为 x.org, wayland 的实现为 wayland compositer.

> 协议为GUI环境提供基本的框架: 在屏幕上描绘, 体现图像与移动程序窗口, 同时也受理/运行/管理电脑与鼠标/键盘的交互程序. 不过, X并没有管理到用户界面, 而是由其他以X为基础的实现来负责. 正因为如此, 以X为基础环境所开发成的视觉样式非常地多, 不同的程序可能有截然不同的接口体现. X作为系统内核之上的程序应用层发挥作用. [Window manager-Arch](https://wiki.archlinux.org/index.php/Window_manager_)

x 主要分为 xclient 和 xserver 两部分, xserver 负责屏幕上绘制各种元素, 窗口移动等, 以及相应外围设备的交互(主要是输入设备). xclient 负责执行程序业务逻辑, 接收xserver发送的事件通知, 即我们启动的GUI程序. xserver 是一个后台进程. 以xorg举例, 通常启动GUI程序的流程为
1. 启动 xserver, 指定端口或使用默认端口(默认6000端口, 标记为第0个xserver, 后续依次递增)
   1. 示例: `X :a.b` : X为xorg程序, a 表示端口, b 目前没有使用.
2. 设定 DISPLAY 环境变量, 用于指定与xclient交互的xserver. 也可以在启动 xclient 时指定xserver
   1. 示例: `export DISPLAY=xxx.xxx.xxx.xxx:0.0`
3. 启动 xclient: `termite --display localhost:0`. termite 表示要执行的软件, localhost 可省略, 0表示监听6000端口的xserver. 如果设定 DISPLAY 变量, 则无需 display 参数

两者的架构区别详情见链接 [Wayland Architecture](https://wayland.freedesktop.org/architecture.html), 图示如下.

![x-architecture](./attach/x-architecture.png) ![wayland-architecture](./attach/wayland-architecture.png)

### xorg
xorg 这里只简单介绍下使用, 有兴趣进一步研究的同学可以学习 x 协议以及 xorg 源码. PS: 了解 xrog 后, 我才知道 wsl 也可以通过 x 开启图形界面...

xorg 的配置文件主要在 `/etc/X11/` 和 `/usr/share/X11/` 下的 `xorg.conf` 和 `xorg.conf.d/` , 加载顺序为 `/usr/share/X11`, `/etc/X11`, 文件夹内加载顺序为 `xorg.conf.d/`, `xorg.conf` . 如果配置之间有冲突, 那么后加载的配置生效.

当 xorg 找不到配置文件时, 会采用默认配置. 新版本 xorg 会自动识别显示器, 其他设备如键鼠显卡等都需要自行配置.

#### startx
startx 做了什么?

startx 其实是脚本, 通过调用 xinit 启动 xclient 和 xserver. 与直接执行xinit不同的是, startx 还负责参数判断/文件断言等操作, 然后将真正使用的配置传递给 xinit.

xinit 是二进制程序, 用法格式为 `xinit [[client] options] [--[server] display options]`
1. 当不指定server时, xinit 会查找 `$HOME` 目录下的 `.xserverrc` (如果不存在则使用 `/etc/X11/xinit/xserverrc` ), 并且调用 `execvp` 执行该文件. options 默认为 `display:0`
2. 当不指定client时, xinit 会查找 `$HOME` 目录下的 `.xinitrc` (如果不存在则使用 `/etc/X11/xinit/xinitrc` ), 并且调用 `execvp` 执行该文件. options 默认为 `xterm -geometry +1+1 -n login -display:0`

xinit 启动时, 会先启动 xserver, 然后依次启动 xclient. 如果有命令是前台执行的, 那么他会阻塞后续命令的执行. 如果最后一个程序时后台执行的, 那么xinit会直接退出, 而不会等待命令执行完成. 除此之外, 当退出最后一个 xclient 时, xinit 也会将 xserver 退出.

startx/xinit 可以理解为 xorg 启动的服务程序, 你可以自己写脚本实现这些功能. 与 xorg 本身并无太大关系

startx 常用的配置文件如下
1. .xinitrc is run by xinit (and therefore also startx). In addition to configuration, it is also responsible for starting the root X program (usually a window manager such as Gnome, KDE, i3, etc.). This usually applies when X is started manually by the user (with starx or similar).
2. .xsession is similar to .xinitrc but is used by display managers (such as lightdm, or sddm) when a user logs in. However, with modern DMs the user can usually choose a window manager to start, and the DM may or may not run the .xsession file.
3. .xprofile is just for setting up the environment when logging in with an X session (usually via a display manager). It is similar to your .profile file, but specific to x sessions.

#### Nvidia显卡配置
正是因为换了Nvidia显卡后, 才开始查阅 xorg 的相关知识. 这里主要说下nvidia显卡如何配置, 以及如何切换 intel 核显.

Arch 安装 xorg 时, 会在 `/usr/share/X11/` 下添加输入设备和显卡设备的配置文件.

Linux显卡配置主要分以下步骤. 注意不要使用 bumblebee 了, 13年开始就不更新了. 图省事的可以使用 optimus-manager, github直接搜索即可.
1. 安装显卡驱动
2. 修改 xorg 显卡配置文件
3. 修改内核模块, 禁用nouveau等其他驱动, 只保留nvidia驱动.
4. 测试独立显卡是否正常工作

安装显卡驱动: 通过如下网站查询显卡支持的驱动版本, 一般新机器直接安装 nvidia 即可: `sudo pacman -S nvidia`
1. [Nvidia-驱动-Arch](https://wiki.archlinux.org/index.php/NVIDIA)
2. [Nvidia 官方文档](https://www.nvidia.com/Download/driverResults.aspx/141847/en-us), 看支持页面有没有自己的显卡.

[xorg 显卡配置文件](/config/xorg/). 配置文件主要有两类, 一类配置输入设备, 一类配置显卡设备. 显示器不用自己配置, 新版本 xorg 可以自动识别.
1. 将配置文件置于 `/usr/share/X11/xorg.conf.d/` 或 `/etc/X11/xorg.conf.d/` 下
2. 当使用Nvidia显卡时, 只启用 `nvidia-outputclass.conf` 配置文件, 当使用集显时, 只启用 `intel-outputclass.conf` 配置文件(修改另一文件名后缀即可).

修改内核模块: 通过修改 `/etc/modprobe.d/` 或 `/usr/lib/modprobe.d/` 即可, 内容如下

```Bash
vim /usr/lib/modprobe.d/nvidia.conf
# 使用 nvidia 闭源驱动时禁用 nouveau
blacklist nouveau

# 禁用 nvidia&nouveau 则会只使用 intel 显卡
# blacklist nvidia_drm
# blacklist nvidia_uvm
# blacklist nvidia_modeset
# blacklist nvidi
```

显卡测试
1. `nvidia-smi`: 输出 Nvidia 显卡信息, 如果当前正在使用Nvidia显卡, 那么Processes下有相应的进程出现.
2. `glxgears`: 测试帧数. 也可以了解下 glxinfo 命令

需要注意的问题
1. arch 官方文档通过配置Device启用Nvidia时不生效的(至少在我这里没有生效), 而且没有作用, 所以无需添加Arch文档的配置.
2. 启用xorg时, 如果启动失败, 那么检查日志看是哪里发生了错误. 另外, xorg 日志中有错误不一定影响xorg的启动, 比如启动后黑屏, 那不一定是xorg的原因, 有可能时独显没有正确配置. 提这个的原因主要是 **提醒大家不要找错方向.** (我就是启动黑屏了, 然后看到日志中有错, 就一直排查日志中的错误, 但真正的原因时独显配置错了). 一般而言, xorg因报错而终止执行, 那么可以排查错误原因, 如果启动过程中报错但是继续执行了, 那么最后没有正确启动的原因可能在其他地方.

### 参考
1. [startx启动过程分析](https://blog.csdn.net/clozxy/article/details/5488699)
2. [NVIDIA Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_)

### 术语
1. DRM: Direct Rendering Manager, 解决多个GUI程序对 Video card 资源的协同使用的问题. 参考: https://blog.csdn.net/dearsq/article/details/78312052

## 窗口管理器
> 参考: [窗口管理器](https://wiki.archlinux.org/index.php/Window_manager_(简体中文))

平铺式窗口管理器时我选择Linux的原因之一.

在平铺式管理器中, 使用比较多的有 i3/sway/dwm/awesome/xmoad. 简介如下
1. dwm 最为精简, 不过每次修改配置都需要该源码(源码只有两千多行, 很精简)
2. xmoad 使用 haskell 语言开发, 如果你熟悉该语言可以尝试此版本.
3. awesome 使用 lua 作为配置语言.
4. sway 是 i3 的 wayland 版.
5. i3wm

其实这几个软件大体上差别并不大, 关于这个我没有特别的建议(因为我也没用过), 有兴趣的同学可以自己逐个尝试下.

### i3wm
> 参考: [i3-arch](https://wiki.archlinux.org/index.php/I3_(简体中文))   

#### 安装
```Bash
# 安装 xorg
sudo pacman -S xorg xorg-xinit 
# feh: 图片查看工具, 用于设置壁纸;  rofi: app启动器, i3lock: 锁屏管理器
sudo pacman -S termite feh rofi scrot i3lock imagemagick
cp /etc/X11/xinit/xinitrc ~/.xinitrc
yay -S i3
```

#### 合成器
> 参考: [Compton](https://wiki.archlinux.org/index.php/Compton)

i3 自身不带半透明, 淡入淡出等特效, 需要安装独立的 compositor(合成器). 
- termite 设置透明度无效就是因为没有 compositor 导致的.
- compton 是一个独立的合成管理器, 可以用来给i3添加各种视觉效果(半透明, 淡入淡出).

使用 compton 作为 i3 的合成器:
1. 安装: `pacman -S compton`
2. 随桌面启动: `vim ~/.xinitrc`, 添加 `exec compton -b &`

问题解决
- 当使用 `nvidia-340xx-utils` 驱动时, 启动 compton 可能报错. 更换驱动为 libglvnd 即可解决.
    - 如果卸载 nvidia-xx 后, 启动 startx 报错, 重新安装 xorg 即可解决: `pacman -S xorg`

#### 启动
因为我没有使用登录管理器, 而是直接使用startx启动的, 方法如下. 具体可参考 [xorg](#xorg)
```Bash
vim ~/.xinitrc
# 在最后一行添加, 原因参照 [xorg](#xorg)
exec i3
# 带日志输出
exec i3 -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
```

#### 用法和配置
i3 的用法参考 [官方文档](https://i3wm.org/docs/userguide.html)
1. 配置文件位置: `~/.config/i3/config`
2. 了解 scraptchpad: 临时窗口存储区, 可以方便的隐藏/调出, 悬浮在所有窗口之上. 类似于 guake, 不过 guake 在上方显示, scraptch 位置可调.
3. 工具
    - 使用 `xprop` 可以查看窗口的class. (具体用法: 在浮动等非覆盖布局下, 输入 xprop, 然后点击窗口)

----

配置

配置i3的快捷键是一件很有意思的事情, 相比于 Win/OSX, 这种自由以及强大的配置, 对某些人有很强的吸引力.

如果你有自己的快捷键方案/指导思想, 那么根据自己的想法配置就好了. 如果没有, 建议使用vim的方案. 我个人的配置方案如下
1. [i3-vim-shortcut](./vim/shortcut.md)
2. [i3配置文件](/config/vim/config)

#### 状态栏Polybar
> [官方文档](https://github.com/jaagr/polybar/wiki)

使用polybar纯粹是网上看的别人的教程, 具体与 i3-bar 的区别有兴趣的同学可以自己尝试下.
1. 安装: `yay -S polybar`
2. 启动: 编写 polybar 启动脚本, 然后将脚本挂载到 i3 配置文件中, 实现随i3启动.
    - [polybar启动脚本示例](./config/polybar/launch.sh)
    - 随i3启动: 在 `~/.config/i3/config` 文件最后添加: `exec_always --no-startup-id $HOME/.config/polybar/launch.sh`, 并注释掉 i3-bar
3. 配置: 参考官方文档
    - emoji 符号推荐 font awesome, 具体参考 [font-install](/setup/soft/setup.d/8-font.sh)

#### HDPI
缩放： 直接在相关软件里设置字体大小即可(不建议使用 xrandr 的缩放, 因为缩放会失去 HDPI 本身的意义)
- 使用xrandr缩放示例: `xrandr --output DP-1 --scale 0.5x0.5`

各软件通过调节字体大小适应高分辨率即可
1. fcitx 字体配置
    - `vim /usr/share/fcitx/skin/classic/fcitx_skin.conf`, 字体 25 即可

#### xrandr-多显示器
> 参考 [xrandr-arch-doc](https://wiki.archlinux.org/index.php/Xrandr_)

xrandr 是 X window 下管理多显示器的工具. 使用xrandr管理多显示器输出.

安装: `sudo pacman -S xorg-xrandr`

常用命令与示例, 不明白的可参考 man 文档
```Bash
xrandr                  # 显示所有可用的显示器, 用于查询显示器的名称以及要输出的分辨率
# 输出图像到 HDMI2 所连接的显示器, 分辨率自适应, 显示在 eDP1 显示器的左边
xrandr --output HDMI2 --mode 3840x2160 --left-of eDP1
# 关闭 HDMI2 连接的显示器
xrandr --output HDMI2 --off
# 更改显示器亮度
xrandr --output HDMI2 --brightness 0.5
# 设置为主屏幕
xrandr --output HDMI2 --primary
```
## 其他
### 字体推荐
大家可以去 [slant](https://www.slant.co/topics/67/~best-programming-fonts#88) 找下最近比较火的编程字体.

或者在 `/usr/share/fonts` 下看看有那些字体, 在 termite/vscode 一个个试试看喜欢那个.

安装, 持续更新参考 [arch 字体安装](/soft/setup/arch/soft/setup.d/8-font.sh)
```Bash
sudo pacman -S --noconfirm -q wqy-microhei ttf-inconsolata
yay -S ttf-mac-fonts
fc-cache -vf
```
