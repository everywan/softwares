- [目录结构](#%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84)
  - [sys/dev/proc](#sysdevproc)
    - [sysfs 与 /sys](#sysfs-%E4%B8%8E-sys)
    - [sysfs 与 proc](#sysfs-%E4%B8%8E-proc)
  - [usr](#usr)
  - [参考](#%E5%8F%82%E8%80%83)

# 目录结构
虽然 Linux 发行版之间存在细微差别, 但是文件系统的布局基本类似. 了解 Linux 的目录结构有助于使用 Linux, 包括但不限于: 去哪里寻找相应的文件,  一个文件应该放到哪个目录下 等等.

可以使用 cd, pushd/popd; ls, tree 命令了解各目录结构.

Linux 常规的目录结构如下
````
/
├── bin -> usr/bin
├── boot
├── dev
├── etc
├── home
├── lib -> usr/lib
├── lib64 -> usr/lib64
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin
├── srv
├── sys
├── tmp
├── usr
└── var
````

目录结构 带简介版
````
/
├── bin -> usr/bin          **基本工具** 目录, 因为超级用户需要的在 sbin 下, 而普通用户使用的放置到/usr/bin 中, bin 已无太大意义, 所以现在大多数 bin 都指向 /usr/bin
├── boot                    操作系统在启动加载期间所用的程序和配置
├── dev                     设备文件(在unix/linux 中,设备以文件形式存在)
├── etc                     配置文件目录, 原意是指 `etcetera`, 既所有其他的, 未分类或者无法分类的
├── home                    用户个人目录
├── lib -> usr/lib          库文件, 提供给多个程序使用的代码段. /lib 目录包含内核模块
├── lib64 -> usr/lib64      同上, 64位库文件
├── media                   外部存储器目录, 一般是 当计算机正在运行时, 自动挂载插入的存储设备. 如 sd 卡等
├── mnt                     用于手动挂载设备或者分区的挂载点
├── opt                     通常存放 大型软件, 或者手动从源码构建的软件, 二进制可执行程序链接到 /opt/bin, 库文件存放到 /opt/lib
├── proc                    类似 /dev, 虚拟目录. 存储有关本计算机的信息, 与 /dev 类似, 文件和目录是在计算机启动或运行时生成的, 因为系统正在运行且会发生变化
├── root                    root 用户的主目录
├── run                     存放自系统启动以来描述系统信息的文件. 可以查阅与 /var/run /dev 的区别以及演变历史
├── sbin -> usr/sbin        与 bin 类似, 不过 /sbin 中只存放超级用户(s_uper)需要的应用程序, 如 fdisk
├── srv                     存储服务器的和服务器产生的数据. 如果你正在 Linux 机器上运行 Web 服务器, 你网站的 HTML文件将放到 /srv/http (或 /srv/www). 如果你正在运行 FTP 服务器, 则你的文件将放到 /srv/ftp.
├── sys                     挂载 sysfs 虚拟文件系统, sysfs统提供了一种比 proc/dev 更为理想的访问内核数据和设备数据的途径, 用于取代 /deb /proc
├── tmp                     临时文件目录, 保存在使用完毕后可随时销毁的缓存文件, 一般重启后清空, 因为不需要 root 权限, 所以也可以用来执行一些临时操作.
├── usr                     usr 是早期 unix 存放用户的主目录. /usr/bin 一般存放用户自己安装的软件或者预装的软件, 与 /bin 不同的是 /bin 存放的是基础工具. 不过, 现在好多发行版中 /bin 已经指向 /usr/bin, 如 centos.
└── var                     系统产生的不可自动销毁的缓存文件, 日志记录
    └── var/log             存放系统日志
````

## sys/dev/proc
以下内容部分摘抄自 [使用 /sys 文件系统访问 Linux 内核](https://www.ibm.com/developerworks/cn/linux/l-cn-sysfs/index.html). 欲详细了解 sysfs, 请参考原文.

### sysfs 与 /sys
sysfs 文件系统总是被挂载在 /sys 挂载点上. 虽然在较早期的2.6内核系统上并没有规定 sysfs 的标准挂载位置, 可以把 sysfs 挂载在任何位置, 但较近的2.6内核修正了这一规则, 要求 sysfs 总是挂载在 /sys 目录上；针对以前的 sysfs 挂载位置不固定或没有标准被挂载, 有些程序从 /proc/mounts 中解析出 sysfs 是否被挂载以及具体的挂载点, 这个步骤现在已经不需要了. 请参考附录给出的 sysfs-rules.txt 文件链接. 

### sysfs 与 proc
sysfs 与 proc 相比有很多优点, 最重要的莫过于设计上的清晰. 一个 proc 虚拟文件可能有内部格式, 如 /proc/scsi/scsi , 它是可读可写的, (其文件权限被错误地标记为了 0444!, 这是内核的一个BUG), 并且读写格式不一样, 代表不同的操作, 应用程序中读到了这个文件的内容一般还需要进行字符串解析, 而在写入时需要先用字符串格式化按指定的格式写入字符串进行操作；相比而言,  sysfs 的设计原则是一个属性文件只做一件事情,  sysfs 属性文件一般只有一个值, 直接读取或写入. 整个 /proc/scsi 目录在2.6内核中已被标记为过时(LEGACY), 它的功能已经被相应的 /sys 属性文件所完全取代. 新设计的内核机制应该尽量使用 sysfs 机制, 而将 proc 保留给纯净的"进程文件系统". 

## usr
usr最早是user的缩写, /usr的作用与现在的/home相同. 而目前其通常被认为是 User System Resources 的缩写, 其中通常是用户级的软件等, 与存放系统级文件的根目录形成对比.

## 参考
- [Linux 文件系统详解 | Linux 中国](https://zhuanlan.zhihu.com/p/38802277)
- [BSD-Unix 目录结构](https://www.freebsd.org/soft/zh_CN/books/handbook/dirstructure.html)
- [目录结构-维基百科](https://zh.wikipedia.org/wiki/文件系统层次结构标准)
- [Linux目录结构-linux_wiki](http://linux-wiki.cn/wiki/zh-hans/Linux目录结构)
