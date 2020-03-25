# ADB
关联： 安卓调试

https://developer.android.com/studio/run/device

安卓设备连接chrome进行Webview调试
1. 安装 android-tools 工具包(主要是adb命令)
2. 添加文件 `/etc/udev/rules.d/51-android.rules`, 内容如下: `SUBSYSTEM=="usb",ATTRS{idVendor}=="18d1",ATTRS{idProduct}=="4ee7",MODE="0666",GROUP="plugdev"`, 其中 idVendor 为 lsusb 中的ID.
3. 修改文件权限为 `a+r`
4. 重启 udev: `sudo udevadm control --reload-rules`
5. 重连手机
6. 执行 `adb devices` 查看设备是否成功链接.
