# FAQ

fcitx 输入法出现漏字: 输入拼音时, 字母直接出现在输入框.
1. 问题复现: 输入 `窗口管理器` 可以测试
2. 修复: 重新安装 `fcitx-im`, 并且重启系统

Trash-cli 恢复系统等意外情况下提示权限不允许
1. 在根目录创建 `/.Trash`, 权限660, 且设置t权限. `chmod a+rw /.Trash;chmod +t /.Trash`

如何移除文字终端下的bell(响铃)
1. `sudo rmmod pcspkr`