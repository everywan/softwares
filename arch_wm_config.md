<!-- TOC -->

- [桌面/中文环境配置](#桌面中文环境配置)
    - [i3桌面配置](#i3桌面配置)
    - [polybar配置](#polybar配置)
    - [中文配置](#中文配置)
        - [中文字体支持](#中文字体支持)
        - [fcitx](#fcitx)

<!-- /TOC -->
# 桌面/中文环境配置
- [arch_xorg介绍](https://wiki.archlinux.org/index.php/Xorg_(简体中文))
- [arch_窗口管理器介绍](https://wiki.archlinux.org/index.php/Window_manager_(简体中文))

名词解释: 桌面环境/窗口管理器/显示管理器
1. 桌面环境: 桌面环境是一个整体的环境, 是一系列桌面软件的集合, 包括应用程序, 窗口管理器, 登录管理器, 桌面程序等等. 如Gnome/KDE 都是桌面环境
2. 窗口管理器: 提供窗口管理的功能, 如窗口的显示/隐藏, 前后/大小等 的程序, 窗口管理器与Xserver直接进行交互(Xorg是服务端, Linux 是C/S结构).
3. 显示管理器: 既登录管理器, 启动后用户看到的第一个图形界面
4. [参考文章](https://my.oschina.net/aspirs/blog/607710)

所以, 一个自定义的完整可用的桌面环境包括: 窗口iu管理器+桌面程序, 一般还搭配任务栏, 锁屏界面等其他程序使用.

显示管理器用于登录, 这里我没有配置. 有需要的可以自行探索下. 

这里推荐尝试下 i3wm, 平铺式的桌面管理器, 比较好玩好用.

## i3桌面配置
- [i3安装_arch](https://wiki.archlinux.org/index.php/I3_(简体中文))
- [i3 配置_官方](https://i3wm.org/docs/userguide.html)
- [简单配置参考](https://blog.csdn.net/k_y_z_s/article/details/79363852)

安装i3
```Bash
# xorg Server 桌面环境基础;  feh是图片查看工具, 用于设置壁纸;  rofi是app启动器
sudo pacman -S xorg xorg-xinit termite feh rofi
cp /etc/X11/xinit/xinitrc ~/.xinitrc
aurman -S i3
```

配置i3
**简洁才是好配置的王道**
1. 修改 `~/.xinitrc`, 添加 `exec i3` 或 `exec i3 -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1` (带日志)
    - 注意, `~/.xinitrc` 中只能有一个生效的 exec, 且exec之后的不会被执行. [参考: xint配置](https://wiki.archlinux.org/index.php/Xinit#xinitrc)
2. 使用以及其他配置 [参考我的配置文件](./config/i3/config).
    - rofi配置: app启动器配置
    - polybar: 状态栏配置
    - 使用 scratchpad: scratchpad 是一个临时窗口存储区域, 可以方便的调出与隐藏. 详细参见i3介绍
3. 出现问题用过 `1` 指定的log文件查看原因


提示技巧
多看配置以及官方文档
1. 工具介绍
    - 使用 `xprop` 可以查看窗口的class. (具体用法: 在浮动等非覆盖布局下, 输入 xprop, 然后点击窗口)
1. `bindsym $mod+t [class="Termite"] focus` 立即切换到指定的窗口
2. `bindsym $mod+a focus left`: 使用 ad 切换前后窗口, shift+ad 移动前后窗口
3. `bindsym $mod+Tab focus output left`: output 表示显示器之间的切换, left表示向左循环切换
    - mode_toggle 表示浮动/固定之间切换, parent表示父元素等切换. 具体查看文档

## polybar配置
- [官方文档](https://github.com/jaagr/polybar/wiki)
- [我的配置文件](./config/polybar/config)
- [特殊符号网站, 用于在状态栏显示图标](http://cn.piliapp.com/symbol/)

安装
1. 安装 polybar: `aurman -S polybar`
2. 运行 polybar: [参考启动脚本](./config/polybar/launch.sh)
3. 配置随i3启动: 在 i3-config 文件最后添加: `exec_always --no-startup-id $HOME/.config/polybar/launch.sh`, 并注释掉 i3-bar.

配置参考官方文档即可.

## 中文配置
### 中文字体支持
- [参考_arch_doc](https://wiki.archlinux.org/index.php/Localization/Simplified_Chinese_(简体中文))

1. 修改 `/etc/locale.gen`, 开启中文/英文选项.(去掉前面的`#`)
2. 执行 `locale-gen` 使系统应用更改
3. `vim /etc/locale.conf`, 添加 `LANG=en_US.UTF-8`
4. 在桌面环境中配置中文: 在 `~/.xinitrc` 中添加
    ```Bash
    export LANG=zh_CN.UTF-8
    export LANGUAGE=zh_CN:en_US
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=zh_CN.UTF-8
    ```
5. 安装中文字体: `sudo pacman -S wqy-microhei`

### fcitx
- [参考](https://wiki.archlinux.org/index.php/Fcitx_(简体中文))

安装
```Bash
# 安装
sudo pacman -S fcitx fcitx-googlepinyin

# 配置 ~/.xinitrc, ~/.xprofile,
# 在 ~/.xinitrc 添加命令, 以加载 ~/.xprofile
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile
# 每次启动(startx)都加载 fcitx. 有些桌面自带启动, 可以先看下有木有自带. -r表示替代原先进程
fcitx -r &

# vim ~/.xprofile, 设置桌面环境变量(没有该文件的话新建一个即可)
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

使用
1 . 根据需求自行修改fcitx配置, 配置文件在 `~/.config/fcitx/config profile; conf/*`
    - 注意必须在退出 fcitx 的情况下才能修改, 否则修改可能会被覆盖.
    -在 `~/.config/fcitx/profile` 中启用中文输入法
    - 详细参见配置文件
2. 其他用法
    - 剪切板: `Ctrl + ;`
