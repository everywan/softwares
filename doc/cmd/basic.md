- [Linux](#linux)
  - [基础知识](#%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86)
    - [脚本执行的四种方式](#%E8%84%9A%E6%9C%AC%E6%89%A7%E8%A1%8C%E7%9A%84%E5%9B%9B%E7%A7%8D%E6%96%B9%E5%BC%8F)
    - [NOHUP](#nohup)
    - [包管理器-APT](#%E5%8C%85%E7%AE%A1%E7%90%86%E5%99%A8-apt)
    - [命令别名-alias](#%E5%91%BD%E4%BB%A4%E5%88%AB%E5%90%8D-alias)
    - [重定向](#%E9%87%8D%E5%AE%9A%E5%90%91)
    - [进程管理器](#%E8%BF%9B%E7%A8%8B%E7%AE%A1%E7%90%86%E5%99%A8)
    - [计数命令-WC](#%E8%AE%A1%E6%95%B0%E5%91%BD%E4%BB%A4-wc)
    - [添加用户或组](#%E6%B7%BB%E5%8A%A0%E7%94%A8%E6%88%B7%E6%88%96%E7%BB%84)
    - [设置环境变量](#%E8%AE%BE%E7%BD%AE%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)
    - [basename/dirname](#basenamedirname)
  - [进阶知识](#%E8%BF%9B%E9%98%B6%E7%9F%A5%E8%AF%86)
    - [文件传输](#%E6%96%87%E4%BB%B6%E4%BC%A0%E8%BE%93)
    - [文本分析-AWK](#%E6%96%87%E6%9C%AC%E5%88%86%E6%9E%90-awk)
    - [文本处理-SED](#%E6%96%87%E6%9C%AC%E5%A4%84%E7%90%86-sed)
    - [网络请求-CURL/WGET](#%E7%BD%91%E7%BB%9C%E8%AF%B7%E6%B1%82-curlwget)
    - [SSH](#ssh)
    - [设置代理](#%E8%AE%BE%E7%BD%AE%E4%BB%A3%E7%90%86)
    - [查看设备信息](#%E6%9F%A5%E7%9C%8B%E8%AE%BE%E5%A4%87%E4%BF%A1%E6%81%AF)
    - [lsof](#lsof)
    - [ulimit](#ulimit)
  - [ETC](#etc)
    - [ARM平台源](#arm%E5%B9%B3%E5%8F%B0%E6%BA%90)

# Linux
> [Bash编程](./bash.md)

## 基础知识
1. shell命令可以添加 `-v` 参数从而在运行时输出日志. 最多加三个,越多日志信息越详细. 如 `ls -vvv`
2. `ctrl+z`: 暂停进程并且将进程放入后台, `jobs`: 显示当前暂停的进程, `bg`: 使进程在后台执行, `fg`: 使进程在前台执行
3. ln 默认或 -n 指定硬连接, -s软链接
4. 设置时间: `date -s "yead-mon-day h:m:s"`
    - `date %H_%M -d 'string'`: 以指定格式输出给定的时间字符串
    - 获取服务器时间: `ntpdate us.pool.ntp.org`
5. [计数命令](#wc计数): `wc -l out`, 统计输出
6. `du -h`: 统计文件夹大小
    - 参考 http://www.cnblogs.com/peida/archive/2012/12/10/2810755.html
7. `w`: 查看登录用户的信息
    - `pkill`: T人

### 脚本执行的四种方式
> 参考 http://blog.csdn.net/jx_jy/article/details/45821017

1. 相对路径方式: `./test.sh`
2. 绝对路径方式: `/tmp/test.sh`
3. bash命令调用: `/bin/bash /tmp/test.sh`
4. 添加空格的相对/绝对路径: `. /test.sh` 或 `. /tmp/test.sh`
5. 四种方式区别
    - 1 2 都需要提前赋予脚本可执行权限, 3 是把脚本当做bash的调用, 所以不需要可执行权限
    - 1 2 3 都是在当前shell开启子shell,然后执行脚本(Linux的环境变量具有继承性, 子shell会继承父shell的环境变量, 但是父shell得不到子shell的环境变量)
    - 4 是在当前shell执行脚本

### NOHUP
1. 作用: 忽略所有挂断(SIGHUP)信号
    - `-d 或者 &` 后台继续执行
2. 执行流程
    - 示例: ssh登陆服务器运行某进程时, 若断开连接, 那么便会发送SIGHUP（挂断）信号, 退出前后台进程
    - 原因: ssh连接服务器时, 会启动一个bash, 在此bash中, 所有的进程都是bash fork() 然后 exec() 出
    - 如果 nohup 执行的命令需要输入, 可以先前台执行, 然后使用 `ctrl + z` 强制停止当前进程,并且转至后台, 然后使用 `bg` 使程序在后台执行

### 包管理器-APT
> http://wiki.ubuntu.org.cn/UbuntuHelp:AptGet/Howto/zh
```Bash
apt update              # 更新源
apt upgrade             # 更新所有已安装的软件包
apt-get dist-upgrade    # 更新整个系统到最新的发行版
apt-get -f install      # 修正依赖,然后安装
apt-get autoclean       # 删除 已删除软件的deb安装包
apt-get clean           # 删除所有软件的deb安装包
    # 安装包缓存的路径为/var/cache/apt/archives，使用 du -sh /var/cache/apt/archives 查看包缓存占用的硬盘空间
dpkg-reconfigure foo    # 重新配置 foo 包
dpkg --set-selections   # 从 STDIN 设置包的selections(如锁定版本)
    # --get/clear-selections
apt-show-versions -u    # 查看系统中那些包可以更新

apt remove foo          # 删除 foo 包,但是保留配置文件
    # --purge          # 不保留配置文件
apt-get autoremove      # 删除为了满足其他软件包的依赖而安装的,但是现在不需要的包

apt-cache search foo    # 搜索和 foo 匹配的包
apt-cache show foo      # 显示 foo包 的相关信息
dpkg -l *foo*           # 显示 foo包 的相关信息,并且显示每个包是否安装
    # 支持正则匹配查找
dpkg -L foo             # 显示 foo包 都安装了哪些文件,以及他们的路径
dlocate file            # 在已安装的包中, 查找foo文件属于那个包
apt-file search file    # 查找foo文件属于那个包,包括源和本地. 需要保持 apt-file 数据库索引的更新
apt-cache pkgnames      # 快速列出已安装的软件名称
```
1. 为apt设置代理
    - **在Ubuntu 10.10及以后版本中, apt-get不再读取`$http_proxy`变量, 所以不能使用`$http_proxy`环境变量**
    - 临时为apt设置代理: `apt-get -o Acquire::http::proxy="http://proxyIP:proxyPort/" update`
    - 永久为apt设置代理: 修改 `/etc/apt/apt.conf` 或者 `~/.bashrc` 配置文件, 添加 `Acquire::http::Proxy "http://proxyIP:proxyPort";` 即可
    - 或者使用指定配置文件: `apt-get -c ~/apt_proxy.conf update`

### 命令别名-alias
1. 在 `/etc/profile` 或者 `~/bashrc.rc` 文件中, 可以给命令/语句添加别名(可以理解为命令的快捷方式)
2. 添加完成后需要使用 `source /etc/profile` 使修改生效
3. 示例: `alias chrome_stdout='google-chrome --headless --disable-gpu --dump-dom $1'`
4. `=`附近不能有空格, `$1`表示参数, 不传参数时可以直接写固定值

### 重定向
1. `>` 清空然后输入, `>>` 追加.　没有文件时都会创建文件
2. 标准IO流
    - STDIN     0   :   `/dev/stdin -> /proc/self/fd/0`
    - STDOUT    1   :   `/dev/stdout -> /proc/self/fd/1`
    - STDERR    2   :   `/dev/stdout -> /proc/self/fd/2`
3. 示例
    ```Bash
    # 标准输出和标准错误都重定向到/dev/null
    ls 1>/dev/null 2>/dev/null
    # STDOUT 和 STDERR
    # 猜测：ls 2> tt.txt & 1> tt.txt
    ls 2>&1 tt.txt
    # PS：不知道为什么, 我使用 &> / 2>&1 会直接输出到屏幕上, 重定向失效
    ```

### 进程管理器
1. TOP: 实时动态显示系统进程
2. PS: 返回系统当前状态的快照
3. PSSTR: 树状格式显示进程

### 计数命令-WC
- `wc -l <文件名>` 输出行数统计
- `wc -c <文件名>` 输出字节数统计
- `wc -m <文件名>` 输出字符数统计
- `wc -L <文件名>` 输出文件中最长一行的长度
- `wc -w <文件名>` 输出单词数统计
- 举例: 统计文件个数： `ls -l|grep "^-"| wc -l`
- `d`表示不包含子目录: `grep "^d"`

### 添加用户或组
- 添加无shell权限的用户
    ```Bash
    # 添加一个用户给 Privoxy
    echo 'privoxy:*:7777:7777:privoxy proxy:/no/home:/no/shell' >> /etc/passwd
    # 用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell
    # 分配个组给 Privoxy
    echo 'privoxy:*:7777:' >> /etc/group
    ```
### 设置环境变量
1. `/etc/profile` ：环境变量配置文件, all_user 永久生效
    - `~/.bashrc`: 每个用户自己的环境变量设置
2. `source /etc/profile` ：立即更新配置文件
3. `echo $JAVA_HOME` ：测试是否添加成功
4. 示例
    ```Bash
    vi /etc/profile
    export JAVA_HOME=/usr/local/jdk1.8
    export PATH=$JAVA_HOME/bin:$PATH
    ```

### basename/dirname
1. dirname/basename: 打印目录或者文件的基本名称
2. 示例
    ```Bash
    pwd                     # /home/wzs/go/src
    dirname  $PWD           # /home/wzs/go
    basename $PWD           # src
    basename test.sh .sh    # test
    basename $PWD/test.sh   # test.sh
    ```

## 进阶知识
1. `!$` 将上一条命令的参数传递给下一条命令参数
    - 更多参考: https://linuxstory.org/mysterious-ten-operator-in-linux/
2. 剪切板_xsel: 复制粘贴扩展. 复制输出到剪切板: `cat ..|xsel -b -i(--input)`, 清除剪切板:`xsel -c`
    - 参考: https://github.com/kfish/xsel, 可采用中键,`ctrl c/v` 方式
3. expect 交互脚本命令
4. time 查看命令执行时间
5. [netstat/ss](https://my.oschina.net/lionel45/blog/109779)
    - 统计socket信息.
    - netstat 属于 net-tools工具集, ss 属于 iproute工具集. iproute 用于替代 net-tools 工具(net-tools 2001年便不再开始维护).

### 文件传输
> IBM文档参考: https://www.ibm.com/developerworks/cn/linux/l-cn-filetransfer/
1. scp: 远程cp命令, 命令格式同cp: `cp -options sourcePath destPath`
2. rsync: 远程数据同步工具只同步源文件和目标文件的不同之处
    - 参考: http://roclinux.cn/?p=2643
    - [rsync数据同步参考](http://roclinux.cn/?p=2643)
    - 命令格式: `rsync main.c machineB:/home/userB`
    - `-l`: 确保数据的一致性, 逐个文件去检查
    - `-z`: zip压缩(gzip算法)
    - `--partial`: 保留那些因故没有完全传输的文件，以是加快随后的再次传输。
3. sftp: 文件传输协议. 与ftp协议类似, 只不过sftp依附于sshd服务, 不需要安装其他程序.
    - [sftp协议](https://zh.wikipedia.org/wiki/SSH文件传输协议)
4. Vscode sftp插件
    - [github介绍地址](https://github.com/liximomo/vscode-sftp)
    - 按 F1 快捷键, 输入 SFTP可查看相关命令
    - 通常情况下配置host,port,name,passwd和remotePath即可.
    - syncMode 默认为update,表示只提交已存在文件内的更改. 修改为full时表示全部更新(包括添加的文件和删除的文件)(full需要登录user有相应的权限)

### 文本分析-AWK
1. 格式: `awk -F ',' cmd`, 注意, 执行cmd时, awk已经将文件拆分成行且每次传入一行到cmd中处理, 而非传入所有行
    - cmd格式: `[BEGIN{}] [[NR==?]{}] [END{}]`, 三个都是可选的,　`BEGIN{}`:逐行读入之前执行, `{}`:每一行的处理, `END{}`:..
    - `[[NR==i],[NR==j]...{}]`表示当在第i/j行时进行处理; NR 表示当前行号
2. `awk -F ','`: 设置切分每行的分隔符
2. awk 内函数并不能执行bash命令, awk编程与bash编程是不同的. 参考: https://www.cnblogs.com/mchina/archive/2012/06/30/2571317.html
    ```Bash
    #!/bin/bash
    // 以指定的格式 +%H_%M 输出目录下所有文件中的时间. 时间在每一行的第二个以 , 分割的位置上
    for file in $(ls)
    do
        cat $file | awk -F ',' '{
            // 使用 \ 作为转义符, 但是需要 "" 修饰. cmd 即为命令的 字符串格式
            cmd="date +%H_%M -d ""\"" $2 "\""
            // 只能通过 system() 或者 getline
            // system() 执行的命令会将输出打印到屏幕(貌似没有办法关闭)
            tt=system(cmd) // 或者 getline cmd
            // close 用来关闭执行的cmd
            close(cmd)
            // 在 awk 内定义的变量并不需要 `$` 来取值
            if(index(tt,$file)!=0){
                print "---------------------------"
            }
        }'
    done
    ```

### 文本处理-SED
1. 格式: `sed [-options] cmd file`
    - `-f filename`: 直接将sed的操作写到文档里
    - `-i`:直接修改读取的档案内容，而不是由萤幕输出
    - `-n`:只有处理过得行才会输出　(默认全部STDIN输出) 
2. 常用命令: 类似于vim中匹配的语法, `选项/old/new/g`. 
    - `a`∶append,a的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
        - `sed '1a add_new_line' file`, `sed '1,2a add_new_line_2' file`
    - `c`∶取代， c 的后面可以接字串，直接取代 n1,n2 之间的行
        - `sed '1,3c replace_line_1_3' file` : 替换整行
    - `s`:取代,可以搭配正则
        - `sed 's/old/new/' file` : 替换当前行的一部分
        - `sed '1s/old_line/new_line'` : 替代整行
    - `d`∶删除
    - `i`∶insert,后面接字串, 会在新的一行出现(目前的上一行)
        - `sed -i '$a bye' file` : 最后一行插入bye
    - `p`∶列印, 同时打印操作的列

### 网络请求-CURL/WGET
- 参考
    - [WGET](http://www.cnblogs.com/peida/archive/2013/03/18/2965369.html), 
    - [CURL](http://www.cnblogs.com/duhuo/p/5695256.html),
    - [区别](https://daniel.haxx.se/docs/curl-vs-wget.html)
- curl: 请求发送工具+请求发送库,支持上传和下载
    - 可以使用postman等GUI工具替代
- wget: 非交互式的文件下载工具
    - 区别: wget支持断点下载(-c), curl模拟请求的库很多
- 下载jdk示例: `wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz`
    - `-c`: 支持断点下载
    - `--header`: 下载所使用的请求头

### SSH
- [参考arch文档](https://wiki.archlinux.org/index.php/Secure_Shell_(简体中文))

远程登录
1. SSH免密登录流程
    - ssh客户端使用 ssh-keygen 生成公钥/秘钥. `ssh-keygen -t rsa -f ~/.ssh/file`. 不需要密码则一直回车即可
    - 复制 .pub 公钥文件到sshd服务端的 `~/.ssh/authorized_keys` 中
        - `ssh-copy-id -i file.pub root@172.26.10.20`
        - `scp file.pub root@172.26.10.20:~/.ssh/`　然后在服务器端, `cat ~/.ssh/file.pub>> ~/.ssh/authorized_keys`
    - 修改服务器文件权限
        ```Bash
        chmod 600 authorized_keys
        chmod 700 ~/.ssh
        ```
    - 修改 sshd 配置
        ```Bash
        # sudo vim /etc/ssh/sshd_config
        RSAAuthentication yes
        PubkeyAuthentication yes
        ```
    - 验证完毕后, 可以关闭密码登录: `PasswordAuthentication no`
2. SSH免密登录多台机器
    - 一对公钥/私钥可以重复使用到多台服务器, 所以大多数情况没有必要生成多个
    -  将公钥复制到服务端后, 在客户端创建 `~/.ssh/config` 文件, 添加以下配置
        ````
        Host server1
            HostName 172.26.10.20
            User root
            IdentityFile /root/.ssh/server1
        ````
    - 使用 `ssh server1` 即可免密登录服务器. 如需添加多台，再添加配置文件即可
3. 如果遇到什么问题
    - 使用 `-vvv` 参数查看调试
    - 查看man文档, 研究下配置文件以及其注释说明

反向代理
1. 建立A机器到B机器的反向代理:
    - `ssh -fCNR [B机器IP或省略]:[B机器端口]:[A机器的IP]:[A机器端口] [登陆B机器的用户名@服务器IP]`
2. 反向代理不会自动重连, 可以使用 autossh 工具建立反向代理(详细参考 arch 官方文档的做法)
    - 使用 systemd 管理autossh时, 首先请先设置免密登录, 然后将密钥拷贝到 `/root/.ssh` 下, 权限修改为 600. 否则在 systemd 启动autossh 时, 会因为没有权限连接而报错(`ssh error status 255`)
    - 也可以使用export脚本自动输入密码, 但是明显不如上面那个方法好
```Bash
# arch 系统安装autossh. 注意保持 sshd 服务的开启
sudo pacman -S autossh
# 2223 监听端口 其他格式与 ssh 建立反向代理相同
autossh -M 2223 -fCNR 2222:localhost:22 user@ip

vim /etc/systemd/system/autossh.service
# [Unit]
# Description=AutoSSH service for port 2222
# After=network.target

# [Service]
# Type=forking
# Environment="AUTOSSH_GATETIME=0"
# ExecStart=/usr/bin/autossh -M 0 -NL 2222:localhost:2222 -o TCPKeepAlive=yes -i /root/.ssh/id_rsa foo@bar.com

# [Install]
# WantedBy=multi-user.target

# 然后就可以使用 systemd 管理autossh了
```

### 设置代理
> 参考： [临时设置](http://www.cnblogs.com/babykick/archive/2011/03/25/1996004.html)
1. 全局代理: 使用 http_proxy环境变量
    - `export http_proxy="http://192.168.1.2:8118"`
    - `export https_proxy="https://192.168.1.2:8118"`
    - 验证是否成功： `curl --proxy http://127.0.0.1:8087 --insecure http://ip.chinaz.com/getip.aspx`
    - 取消代理: `export https_proxy=""`

### 查看设备信息
1. `dmidecode` 命令: 获取 Linux 下各个硬件的信息
    - DMI: 在遵循 SMBIOS规范 的前提下,收集电脑系统信息.
    - SMBIOS(System management BIOS)规范: 主板或系统制造者以标准显示产品管理信息所遵循的统一规范
    - dmidecode: 将 dmi 数据库中的信息解码以可读的文本展示
1. 查看显卡信息: `lspci | grep -i vga`
    - 根据编号查看显卡详细信息: `lspci -v -s ID`
    - NVIDIA信息: `nvidia-smi`
2. 查看网卡信息: `lspci | grep -i 'eth'`
    - `ip/ifconfig`:iproute/net-tools
3. 查看CPU信息: `lscpu`
    - 每个CPU信息: `cat /proc/cpuinfo`
4. 查看内存信息: `free -m`
    - 查看内存使用情况: `cat /proc/meminfo`
5. 查看硬盘信息: `lsblk`
    - 查看分区信息: `fdisk -l`
    - 查看使用情况: `df -hl`

### lsof
> https://www.ibm.com/developerworks/cn/aix/library/au-lsof.html
1. lsof: `list open files`, 即列出打开的文件.
2. 默认输出文件格式如下, *文件描述符对照表暂时没有整理*

|进程名称 | PID| USER|文件描述符|文件格式描述| 磁盘名称| SIZE/OFF| NODE| NAME|
|:------|:---|:----|:--|:----|:------|:--------|:----|:----|
|COMMAND| PID| USER| FD| TYPE| DEVICE| SIZE/OFF| NODE| NAME|
|systemd|   1| root|rtd| DIR |8,8    |     4096|2    | /   |

3. `/proc`目录: 包含内核和进程树的相关的各种文件. 这些文件和目录并不存在于磁盘中, 因此当您对这些文件进行读取和写入时, 实际上是在从操作系统本身获取相关信息
    - 大多数与 lsof 相关的信息都存储于以进程的 PID 命名的目录中, 所以 `/proc/1234` 中包含的是 PID 为 1234 的进程的信息
    - 在进程目录中d额各种文件包含了 进程的内存空间,文件描述符列表,指向磁盘上的文件的符号链接和其他系统信息 等各种数据.lsof程序 使用该信息和其他关于内核内部状态的信息来产生其输出.
4. 常用用法
    - `lsof -p pid`: 根据进程号筛选输出
    - `lsof -d txt`: 根据文件类型筛选
    - `lsof /`: 根据文件筛选
5. 使用lsof恢复删除文件
    - 原理: 当删除文件时, 如果有用户/进程仍在使用这个文件,那么这个文件其实并没有被真正删除. 因为进程并不知道文件已经删除,它仍然可以向打开该文件时提供给它的文件描述符进行读取和写入.除了该进程之外, 这个文件是不可见的, 因为已经删除了其相应的目录条目.
    - 恢复方法
        - 使用lsof查看是否有进程正在使用此文件: `lsof|grep /delete_file`,假设结果如下
            - `httpd   2452    root    2w  REG 33,2    499 3090660  /delete_file(deleted)`
            - `httpd   2452    root    7w  REG 33,2    499 3090660  /delete_file(deleted)`
            - 文件描述符2表示标准错误; 所以下面那行是有效的.
        - 在 `/proc/pid/fd/fdNum` 文件夹查找响应文件. 此示例中文件夹为: `/proc/2452/fd/7`
            - 此时可以通过 cat/cp/ 等等命令恢复文件(此时文件很可能已经损坏,所以建议先CP复制文件后,再查看文件)

### ulimit
> 限制系统用户对shell资源的访问
> ulimit 用于限制 shell 启动进程所占用的资源，支持以下各种类型的限制：所创建的内核文件的大小、进程数据块的大小、Shell 进程创建文件的大小、内存锁住的大小、常驻内存集的大小、打开文件描述符的数量、分配堆栈的最大大小、CPU 时间、单个用户的最大线程数、Shell 进程所能使用的最大虚拟内存。同时，它支持硬资源和软资源的限制。

作为临时限制，ulimit 可以作用于通过使用其命令登录的 shell 会话，在会话终止时便结束限制，并不影响于其他 shell 会话。而对于长期的固定限制，ulimit 命令语句又可以被添加到由登录 shell 读取的文件中，作用于特定的 shell 用户
- `ulimit -a`: 显示所有当前shell资源限制
- 查看所有进程的文件: `lsof |wc -l`
- 查看某个进程打开的文件数: `lsof -p pid |wc -l`
- 临时更改进程打开的文件数限制为8096: `ulimit -n 8096`

## ETC
1. tlp: 充电阀值控制 [链接](https://my.oschina.net/jackywyz/blog/724423)
2. xinput: 控制输入设备 [调节小红点示例](http://www.jianshu.com/p/b9677e9e56ec)

### ARM平台源
- `2017年 08月 13日 星期日 01:36:53 CST` 更新
````
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-updates main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main universe restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main universe restricted

deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-security main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-security main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial main universe restricted
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ xenial main universe restricted
````