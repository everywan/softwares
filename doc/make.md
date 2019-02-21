- [从源码编译](#%E4%BB%8E%E6%BA%90%E7%A0%81%E7%BC%96%E8%AF%91)
  - [.configure](#configure)
  - [make](#make)
  - [make install](#make-install)
  - [ETC](#etc)

# 从源码编译
> 原理肯定不是一个小结能说完的, 详细的等以后看完 《程序员的自我修养》 再补充, 此处简单讲下使用  
> [参考](http://www.linuxidc.com/Linux/2011-02/32211.htm)

## .configure
> ./configure: 检测安装平台的目标特征. 比如它会检测你是不是有CC或GCC, 并不是需要CC或GCC.

- configure是一个shell脚本, 它可以自动设定源程序以符合各种不同平台上Unix系统的特性, 并且根据系统叁数及环境产生合适的Makefile文件或是C的头文件(header file), 让源程序可以很方便地在这些不同的平台上被编译连接
- 可以通过在 configure 后加上参数来对安装进行控制
    - `/configure –prefix=/usr`: 将该软件安装在 `/usr` 下面. 如此, 执行文件就会安装在 `/usr/bin` （默认 `/usr/local/bin` ), 资源文件安装在 `/usr/share` (默认`/usr/local/share`)
    - `./configure –help`： 查看更多帮助

## make
> make: 编译. 从Makefile中读取指令, 然后编译

- 大多数的源代码包都经过这一步进行编译(perl或python编写的软件需要调用perl或python来进行编译)
- 如果在 make 过程中出现error, 可以记下错误代码（整个日志以及环境）, 然后你可以向开发者提交 bugreport(一般在 INSTALL 里有提交地址)
- 当然大多数都是你的系统少了一些依赖库, 或者OS/平台支持等

## make install
> make install: 安装, 也从Makefile中读取指令, 然后安装到指定的位置

- 有些软件需要先运行 make check 或 make test 来进行一些测试
- 如果用bin_PROGRAMS宏的话, 程序会被安装至/usr/local/bin这个目录
- 一般需要root权限, 因为会向系统写文件

## ETC
- make clean: 清除编译产生的可执行文件及目标文件(object file, *.o)
- make distclean: 除了清除可执行文件和目标文件外, 把configure所产生的Makefile也清除掉
- make dist: 将程序和相关的档案包装成一个压缩文件以供发布. 执行完在目录下会产生一个以PACKAGE-VERSION.tar.gz为名称的文件.  PACKAGE和VERSION这两个变数是根据configure.in文件中`AM_INIT_AUTOMAKE(PACKAGE, VERSION)` 的定义
- make distcheck: 和make dist类似, 但是加入检查包装后的压缩文件是否正常. 这个目标除了把程序和相关文件包装成tar.gz文件外, 还会自动把这个压缩文件解开, 执行 configure, 并且进行make all 的动作, 确认编译无误后, 会显示这个tar.gz文件可供发布了. 这个检查非常有用, 检查过关的包, 基本上可以给任何一个具备GNU开发环境-的人去重新编译. 