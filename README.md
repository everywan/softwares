# arch 安装与配置

十一抽空尝试了下arch, 感觉还是不错的, 可玩/可定制性很高.对于即将入坑同学的建议:
1. 对于linux桌面字体的渲染不要抱有太高的希望
2. 如果你特别想定制桌面/快捷键等等, 即高度希望可定制, 那么这套系统很可能适合你.
3. i3平铺式桌面需要一段时间的适应,建议刚开始不要在干活的机器上搞这个.
4. 备份好自己的数据, 准备好折腾的信心.
5. over

**arch: without unnecessary additions or modifications**

1. [arch安装教程](./arch_install.md)
2. [系统安装配置](./arch_config.md)
3. [i3wm桌面环境安装配置](./arch_wm_config.md)
4. [config目录](./config/): 直接从我的config中copy过来的
5. [脚本](./script)
    - [ssh端口转发+mycli+退出自动断开端口转发](/script/ssh_mysql.sh)

![示例](i3-demo.png)

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
