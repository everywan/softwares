# 环境变量
环境变量设置方式:
1. 修改 系统级环境变量文件: `/etc/profile /etc/profile.d/`
2. 修改 用户级环境变量文件: `~.bashrc .zshrc(zsh)`
3. 直接导入: `export GOPATH=""`

区别： .zshrc 每次打开终端时都会加载一次, 而 /etc/profile 是面对多用户的, 只有在用户登录时才会加载一次.
