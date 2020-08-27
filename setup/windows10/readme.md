# win
笔记本上 win 的配置

## 软件安装
1. win store 下载软件
    - 下载 wlinux/pengwin. 用于wsl. 原名wlinux, 后改名 pengwin. 或者下载 ubuntu 也可以.
    - 下载 windows terminal. 用于 ssh 链接
    - x410(可选), 用于 xserver, 不考虑 Linux GUI 的话不需要
2. 网上下载软件
    - vscode, 编辑器. 插件推荐:
        - chinese, 中文插件
        - remote, 远程编辑, 配合 wsl 等.
        - go/markdown 等按需使用的插件
    - ss. 建议直接将配置文件放在 onedrive
    - chrome, 要和linux同步啊, 而且 chrome 真的好用. 插件: 自动云同步即可.
        - win 键位与 linux 键位不同.
3. wsl bash
    - spacevim: `curl -sLf https://spacevim.org/cn/install.sh | bash`
    - [zsh](/setup/arch/soft/setup.d/8-zsh.sh)
    - [git config](/setup/arch/soft/setup.d/9-git-config.sh)
    - tig 
4. sshd 配置: 参考 [nas-win-ssh](/setup/nas/winserver/wsl/sshd.md)
5. 随win自启动配置: 参考 [nas-win-init](/setup/nas/winserver/wsl/init.md)

wsl 需要安装的软件, 如有不同, 会在 [./wsl](./wsl) 下写. 部分与 arch 相同的, 直接在 arch 中寻找即可.

## 配置
将 wsl目录 固定到文件夹.
1. wsl 安装路径一般为: `C:\Users\zhens\AppData\Local\Packages`. Pengwin 的安装文件夹为 `WhitewaterFoundryLtd.Co.随机string`
2. 根目录路径: `LocalState\rootfs`

### pengwin
安装后执行 `pengwin-setup` 即可
### windows-termite
win-termite 更新比较快, 这里写的后续可能就不适用了.

推荐大家关注 github 官方文档介绍. 
- [github](https://github.com/microsoft/terminal)
- [SettingsSchema](https://github.com/microsoft/terminal/blob/master/soft/cascadia/SettingsSchema.md)

配色推荐网站 http://terminal.sexy/

配置文件见 [示例](./config/windows-terminal.json)
