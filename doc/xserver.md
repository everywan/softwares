`startx`: 启动 Xserver 与 Xclient

`sudo X`: 启动 X 服务器, 默认端口6000, 第0个服务器.
- 格式: `sudo X :a.b`, a表示端口, 从6000开始. 如 :0=>6000, :1=>6001. b暂且无用处

客户端直接执行: `termite --display localhost:0`. termite 表示要执行的软件, localhost 可省略, 0表示监听6000端口的xserver.

或者导入 DISPLAY 环境变量, xclient 会自动读取. `export DISPLAY=xxx.xxx.xxx.xxx:0.0`

对于win, 需要开通6000端口, 或者通过端口转发映射6000端口.

术语介绍
1. .xinitrc is run by xinit (and therefore also startx). In addition to configuration, it is also responsible for starting the root X program (usually a window manager such as Gnome, KDE, i3, etc.). This usually applies when X is started manually by the user (with starx or similar).
2. .xsession is similar to .xinitrc but is used by display managers (such as lightdm, or sddm) when a user logs in. However, with modern DMs the user can usually choose a window manager to start, and the DM may or may not run the .xsession file.
3. .xprofile is just for setting up the environment when logging in with an X session (usually via a display manager). It is similar to your .profile file, but specific to x sessions.

问题
1. startx 做了什么
2. xinit 做了什么
3. X server 如何被启动的
4. X client 如何被启动的

参考
1. https://blog.csdn.net/clozxy/article/details/5488699

startx 实际上调用的 xinit, xinit 执行 X 程序, 最后调起 xserver, 启动xserver 相关设置通过参数/或者xinitrc等配置文件传入, 如监听端口等.

当指定 Xserver 时(通过DISPLAY环境变量指定端口, 从而确定xserver), 直接执行 GUI 程序就可以将相关数据传递给xserver, xserver 将数据给渲染器, 渲染出图(其中, 显卡如何参与的正在看)

xinit: 二进制程序, 用法: xinit [[client] options] [--[server] display options].

当不指定client时, xinit 会查找 HOME 目录下的 .xinitrc(如果不存在则使用 /etc/X11/xinit/xinitrc), 并且调用 execvp 执行该文件. options 默认为 xterm -geometry +1+1 -n login -display:0

当不指定server时, xinit 会查找 HOME 目录下的 .xserverrc(如果不存在则使用 /etc/X11/xinit/xserverrc), 并且调用 execvp 执行该文件. options 默认为 display:0 (6000端口).

xinit 启动时, 会先启动 xserver, 然后依次启动 xclient. 如果有命令是前台执行的, 那么他会阻塞后续命令的执行. 如果最后一个程序时后台执行的, 那么xinit会直接退出, 而不会等待命令执行完成.


当退出最后一个xclient时, xserver 也会退出. 这是比我们自己写启动脚本的好处.

startx: 脚本, 通过调用xinit实现相应功能. 执行参数判断/文件断言等操作, 然后将真正使用的配置传递给 xinit.


好了, 回归最后一个问题, Xorg是如何启动的, 与独显/集显如何交互的

/etc/X11/xorg.conf 为主要配置文件, 且在 /etc/X11/xorg.conf.d/ 下的 .conf 配置文件会被视为 xorg.conf 的一部分进行处理, 格式为 XX-name.conf. 如果配制之间有冲突, 则使用最后解析的配置, xorg.conf 最后一个被解析.

当 xorg 找不到配置文件时， 会使用默认(built-in)配置. 但是， 新版本的xorg会自动识别显示器,  但是无法处理输入设备， 所以我们至少需要配置输入设备, 否则桌面不会响应任何操作.

对于显卡
1. 当去除显卡的xorg.conf配置时(删除xorg.conf中的 OutputClass Section), xrandr 显示 HDMI2, 当不去除时， 显示为 HDMI-2, 当使用独显并且添加 Device 节点时, 显示为 HDMI-2-2

```
Section "Module"
    Load	   "modesetting"
EndSection

Section "Device"
    Identifier     "nvidia"
    Driver         "nvidia"
    BusID	   "1:0:0"
    Option	   "AllowEmptyInitialConfiguration"
EndSection
```

禁用显卡文件位置
```Conf
# 使用 nvidia 闭源驱动时禁用 nouveau
blacklist nouveau

# 禁用 nvidia&nouveau 则会只使用 intel 显卡
# blacklist nvidia_drm
# blacklist nvidia_uvm
# blacklist nvidia_modeset
# blacklist nvidia
```
/etc/modprobe.d/
/usr/lib/modprobe.d/

使用 /usr/share/X11/xorg.conf.d/ 切换显卡, 将其分开写到两个配置文件， 需要那个显卡生效时就启用那个文件
```Conf
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
```


extra/xf86-video-fbdev

glxgears： 测试帧数
glxinfo | grep "direct rendering"： 了解 glxinfo

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

术语介绍
1. DRM: Direct Rendering Manager, 解决多个GUI程序对 Video card 资源的协同使用的问题. 参考: https://blog.csdn.net/dearsq/article/details/78312052

