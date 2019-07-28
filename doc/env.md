# 环境变量
环境变量设置方式:
1. 修改 系统级环境变量文件: `/etc/profile /etc/profile.d/`
2. 修改 用户级环境变量文件: `~.bashrc .zshrc(zsh)`
3. 直接导入: `export GOPATH=""`

当 Zsh 启动时, 它会按照顺序依次读取下面的配置文件
- [zsh_env](https://wiki.archlinux.org/index.php/Zsh_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

|file|介绍|只对当前用户生效|
|:--|:--|:---|
|`/etc/zshenv`|该文件应该包含用来设置PATH 环境变量及其他一些环境变量的命令|`~/.zshenv`|
|`/etc/zsh/zprofile`|全局的配置文件, 在用户登录的时候加载|`~/.zprofile`|
|`/etc/zsh/zshrc`|每次打开shell时执行一次|`~/.zshrc`|
|`/etc/zsh/zlogin`|在登录完毕后加载的一个全局配置文件|`~/.zlogin`|
|`/etc/zsh/zlogout`|在注销的时候被加载的一个全局配置文件|`~/.zlogout`|


另外, 当 xinit 启动时, 会依次读取如下配置文件
- [xprofile](https://wiki.archlinux.org/index.php/Xprofile_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

|file|介绍|
|:--|:--|
|`~/.xinitrc`|执行 xinit/starx 时加载|
|`~/.xprofile`|某些显示管理器会在启动时加载该文件|

需要注意的是
1. 对于 .zshrc, 如果设置 zsh 为默认 shell, 那么在登陆时会加载一次 .zshrc, 启动 X 后, 打开shell(如termite)会再加载一次.
2. alias 只对当前shell有效, 不会被子shell继承.

推荐设置策略(如用zsh则替换为相应的zsh配置文件)

|action|file|
|:---|:---|
|定义别名|`~/.bashrc`|
|对所有用户生效|`/etc/profile`|
|对登录用户生效|`~/.profile`|

