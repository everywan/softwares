# 中文支持
Linux启用的中文支持需要设置三部分
1. 启用中文支持
2. 安装中文字体([字体安装脚本](/setup/soft/setup.d/8-font.sh))
3. 中文软件支持, 如输入法等.

## 启用中文支持
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

## 输入法
fcitx 是 Linux 下最常用的输入法. 配置流程如下
1. 安装: `sudo pacman -S fcitx-im`. 中文优先推荐搜狗输入法: `yay -S fcitx-sogoupinyin`.
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

一些容易被忽视的用法
1. 剪切板: `Ctrl + ;`

### bug修复
fcitx 输入法出现漏字: 输入拼音时, 字母直接出现在输入框.
1. 问题复现: 输入 `窗口管理器` 可以测试
2. 修复: 重新安装 `fcitx-im`, 并且重启系统

## 参考
1. [中文支持](https://wiki.archlinux.org/index.php/Localization/Simplified_Chinese_(简体中文))
2. [xprofile-vs-xsession-vs-xinitrc](https://stackoverflow.com/questions/41397361/xprofile-vs-xsession-vs-xinitrc)
3. [fcitx](https://wiki.archlinux.org/index.php/Fcitx_(简体中文))
