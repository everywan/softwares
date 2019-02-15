### 中文支持
> 参考 [中文支持](https://wiki.archlinux.org/index.php/Localization/Simplified_Chinese_(简体中文))

术语介绍
1. .xinitrc is run by xinit (and therefore also startx). In addition to configuration, it is also responsible for starting the root X program (usually a window manager such as Gnome, KDE, i3, etc.). This usually applies when X is started manually by the user (with starx or similar).
2. .xsession is similar to .xinitrc but is used by display managers (such as lightdm, or sddm) when a user logs in. However, with modern DMs the user can usually choose a window manager to start, and the DM may or may not run the .xsession file.
3. .xprofile is just for setting up the environment when logging in with an X session (usually via a display manager). It is similar to your .profile file, but specific to x sessions.

启用arch的中文支持: 需要设置正确的locale并安装合适的中文字体. 流程如下
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


#### 输入法
> 参考 [fcitx](https://wiki.archlinux.org/index.php/Fcitx_(简体中文))

fcitx 是 Linux 下最常用的输入法. 配置流程如下
1. 安装: `sudo pacman -S fcitx-im`. 优先推荐搜狗输入法: `yay -S fcitx-sogoupinyin`.
   1. 同时需要在 `.config/fcitx/profile` 中启用相应的拼音输入法
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