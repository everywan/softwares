## OSX 初始化安装
<!-- TOC -->
- [OSX 初始化安装](#osx-初始化安装)
    - [脚本安装](#脚本安装)
    - [手动安装](#手动安装)
    - [配置恢复](#配置恢复)
    - [iTerm2配置指南](#iTerm2配置指南)
    - [设置快捷键启动](#设置快捷键启动)
<!-- /TOC -->

### 脚本安装
执行以下命令即可， [脚本源码点这里](./config.sh)
```Bash
curl -sSL https://github.com/everywan/soft/blob/master/os/osx/config.sh | sh -
```

### 手动安装
下载安装
- [搜狗输入法-下载地址](https://pinyin.sogou.com/mac/)
- [vscode-下载地址](https://code.visualstudio.com/)
- [chrome-下载地址](https://www.google.com/chrome/) 
- [vmware-下载地址](https://www.vmware.com/go/getfusion)
    - [vmare配置](./vmare/vmare.md)
- [Navicat Premium](http://xclient.info/s/navicat-premium.html?t=c0321e621d18b21e2ba8791a627b3f9bc45dd6a9)
    - 下载完打开时, 会报错, 执行以下命令 `xattr -cr /Applications/Navicat\ Premium.app/`, 然后就可以正常打开了.
- [ss配置教程(脚本已安装命令行ss)](/collect/soft/shadowsocks.md)
- Alfred: 推荐, 但是我没有用. 更习惯使用 下拉终端替代Alfred的命令执行, cli版本的ydcv替代词典, 其他的功能对我用处不大.

商店安装
- wechat
- 网易云音乐

### 配置恢复
执行以下命令即可.
```Bash
# 备份
curl -sSL https://github.com/everywan/soft/blob/master/os/osx/script/backup-restore.sh backup | sh -
# 恢复
curl -sSL https://github.com/everywan/soft/blob/master/os/osx/script/backup-restore.sh restore | sh -
```

#### iTerm2配置指南
- [iTerm2配置-参考文章](http://huang-jerryc.com/2016/08/11/打造高效个性Terminal（一）之%20iTerm/)
- iterm2恢复方法是将备份的json文件存入iterm恢复目录, 再次打开iterm会自动导入该配置文件, 但是配置目录并不是这里. 所以导入完成后, 就可以删除这个文件了(目录见配置文件)
- 修改如下
    - 增加 hotkey window: 下拉终端, 快捷键 cmd+f2. 类似 linux-guake
    - 修改透明度
    - 添加 option+左右键 以单词为单位移动

#### 设置快捷键启动
- 创建 自动操作脚本, 里面可选shell命令. 完成后移动到 `~/Library/Services` 目录即可在 设置->键盘->快捷键->服务->通用 下找到该选项, 设置快捷键即可
- 创建shell命令如下
    ```Bash
    open /Applications/iTerm.app/
    exit 0
    ```
