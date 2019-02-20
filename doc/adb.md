# ADB
关联： 安卓调试

https://developer.android.com/studio/run/device

lsusb 查看设备是否链接上, 
1. 添加 udev 规则, 替换id 为上述id
2. 安装 android-tools 工具包(主要是adb命令)
3. 修改权限`chmod a+r /etc/udev/rules.d/51-android.rules`
4. 添加用户到组: `usermod -a -G adbusers wzs `
5. 重启 udev: `sudo udevadm control --reload-rules`
