## wsl
wsl(Windows Subsystem for Linux) 是一个为在Windows 10上能够原生运行Linux二进制可执行文件(ELF格式)的兼容层.

经实验, 在命令行情况下wsl已经做的不错了, 基本没什么bug了. 但是在桌面(xserver)还存在很大的问题, 只能说达到了勉强可用的程度.

但是以下原因让我倾向选择原生archLinux
1. 更喜欢 i3wm 桌面, 但是win下借助 xserver 使用i3还是有些卡. (不知道是因为电脑配置过时的缘故?)
2. 命令行打开win软件参数无效, 比如经常使用的 `code git/arch_i3`, 在 win 上市行不通的.
3. 目前已知的bug: systemd 不能使用, 以及增加的未知性.

不过, wsl的亮点无可掩埋, 相比较原先的powershell, 强的不是一星半点; 而且我感觉, 比osx的终端也好用多了, 所以, 阻止我使用win替换osx的原因就只有: 
1. osx 整体的设计风格: 其实uwp挺不错的, 国内只不过这一票垃圾厂商太拖后腿. (尤其是阿里腾讯, 以及搜狐等等)
2. win自身的快捷键系统还是有待改进.

[wsl+arch 教程](./wsl/readme.md)

配置之后的 i3wm+wsl 如图示
![wsl-i3](./attach/wsl-i3.jpg)