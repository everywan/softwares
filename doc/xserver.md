
问题
1. startx 做了什么
2. xinit 做了什么
3. X server 如何被启动的
4. X client 如何被启动的

参考
1. https://blog.csdn.net/clozxy/article/details/5488699



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

xorg 日志输出的错误并不一定真正影响最后的使用. 不要在这里浪费太多的时间.
arch nvidia op.. 官方文档给出的 xorg.conf 是没有必要的， 多参考 `/user/share/X11/xorg.conf.d` 下的配置. 主要是
1. outputclass: 与显卡有关
2. libinput: 输入设备
3. 显示器不需要配置， 新版的 xorg 会自动配置显示器。 除非你有特殊需求。

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

