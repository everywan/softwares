# OSX 初始化安装
<!-- TOC -->
- [OSX 初始化安装](#osx-初始化安装)
    - [脚本安装](#脚本安装)
    - [手动安装](#手动安装)
    - [配置恢复](#配置恢复)
    - [iTerm2配置指南](#iTerm2配置指南)
    - [设置快捷键启动](#设置快捷键启动)
<!-- /TOC -->

## 脚本安装
执行以下命令即可， [脚本源码点这里](./config.sh)
```Bash
curl -sSL https://github.com/everywan/soft/blob/master/os/osx/config.sh | sh -
```

## 手动安装
下载安装
- [搜狗输入法-下载地址](https://pinyin.sogou.com/mac/)
- [karabiner-elements](https://karabiner-elements.pqrs.org/). 改键工具

## 配置
### item2
首次配置:
. 字体大小修改为 14. `setting->profile->text`
. 修改为半透明. `setting->profile->windows.transparency`

配置一次后, 建议保存配置, 后续直接回复配置即可.

### 设置快捷键启动
- 创建 自动操作脚本, 里面可选shell命令. 完成后移动到 `~/Library/Services` 目录即可在 设置->键盘->快捷键->服务->通用 下找到该选项, 设置快捷键即可
- 创建shell命令如下
    ```Bash
    open /Applications/iTerm.app/
    exit 0
    ```
