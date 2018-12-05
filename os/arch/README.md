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

[wsl+arch 教程](./wsl/readme.md)
