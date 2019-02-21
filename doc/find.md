- [查找命令](#%E6%9F%A5%E6%89%BE%E5%91%BD%E4%BB%A4)
  - [find](#find)
    - [常用](#%E5%B8%B8%E7%94%A8)
    - [xargs](#xargs)
  - [grep](#grep)
    - [与正则变化的几点 (需要加`\`才能使用,其他与正则相同)](#%E4%B8%8E%E6%AD%A3%E5%88%99%E5%8F%98%E5%8C%96%E7%9A%84%E5%87%A0%E7%82%B9-%E9%9C%80%E8%A6%81%E5%8A%A0%E6%89%8D%E8%83%BD%E4%BD%BF%E7%94%A8%E5%85%B6%E4%BB%96%E4%B8%8E%E6%AD%A3%E5%88%99%E7%9B%B8%E5%90%8C)
    - [常用选项](#%E5%B8%B8%E7%94%A8%E9%80%89%E9%A1%B9)
    - [示例](#%E7%A4%BA%E4%BE%8B)
  - [locate](#locate)
  - [whereis](#whereis)
  - [which](#which)
  - [type](#type)

# 查找命令
## find
> 介绍: 可以指定按照 文件名,权限,修改时间,文件类型 等等,在在一个目录（及子目录）中搜索文件.   
> [原文/参考链接](http://www.cnblogs.com/skynet/archive/2010/12/25/1916873.html)

### 常用
1. 格式: `find [path] [expression]`
2. expression 分为 `-option`, `-print`, `-exec`, `-ok`
3. `-print` : 将匹配的文件输出到标准输出
4. `-exec` : 对匹配的文件执行该参数所给出的shell命令
    - 示例: `find . -name test.py -exec cat {} \;`
5. `-ok`: 和`-exec`相同，除了在执行每一个命令之前，都会让用户确认是否执行
6. `option` 分为以下几个选项
7. `-name`: 按名称查找, 支持正则
8. `-type` 按照type查找
    - d 目录文件, l 符号链接文件, f 普通文件
    - 示例: `find . ! -type d –print`
9. `-perm `: 按照权限
10. `-prune` : 在 path 下查找文件但不在 prune 指定的文件夹下查找
    - 使用 `-deepth` 设置会忽略 `-prune` 设置
11. `-mtime -n +n` : 按照更改时间查找,`-n` 表示文件更改时间距现在n天以内，`+n`表示文件更改时间距现在n天以前
    - 示例: `find / -mtime -5 –print`

### xargs
在使用find命令的`-exec`选项处理匹配到的文件时， find命令将所有匹配到的文件一起传递给exec执行。但有些系统对能够传递给exec的命令长度有限制，这样在find命令运行几分钟之后，就会出现溢出错误。错误信息通常是“参数列太长”或“参数列溢出”。这就是xargs命令的用处所在，特别是与find命令一起使用。

find命令把匹配到的文件传递给xargs命令，而xargs命令每次只获取一部分文件而不是全部，不像`-exec`选项那样。这样它可以先处理最先获取的一部分文件，然后是下一批，并如此继续下去。

在有些系统中，使用-exec选项会为处理每一个匹配到的文件而发起一个相应的进程，并非将匹配到的文件全部作为参数一次执行；这样在有些情况下就会出现进程过多，系统性能下降的问题，因而效率不高；

而使用xargs命令则只有一个进程。另外，在使用xargs命令时，究竟是一次获取所有的参数，还是分批取得参数，以及每一次获取参数的数目都会根据该命令的选项及系统内核中相应的可调参数来确定。

xargs命令同find命令一起使用的一些例子:
- find . -type f -print | xargs file 查找系统中的每一个普通文件，然后使用xargs命令来测试它们分别属于哪类文件
- find / -name "core" -print | xargs echo "" >/tmp/core.log 在整个系统中查找内存信息转储文件(core dump) ，然后把结果保存到/tmp/core.log 文件中：
- find . -type f -print | xargs grep "hostname" 用grep命令在所有的普通文件中搜索hostname这个词
- find ./ -mtime +3 -print|xargs rm -f –r 删除3天以前的所有东西 （find . -ctime +3 -exec rm -rf {} \;）
- find ./ -size 0 | xargs rm -f & 删除文件大小为零的文件

find命令配合使用exec和xargs可以使用户对所匹配到的文件执行几乎所有的命令。

## grep
grep: 使用正则表达式搜索标准输出/文件，并打印匹配的行

### 与正则变化的几点 (需要加`\`才能使用,其他与正则相同)
- `\(..\)` : 分组匹配字符. 示例 ： `\(linux\)` ，linux被标记为第一组
- `\<` ： 锚定单词的开始，如：`\<grep` 匹配包含以grep开头的单词的行
- `\>` : 锚定单词的结束
- `\{m\}` 连续重复字符m次，如：`o\{5\}`匹配包含连续5个 o 的行
- `\{m,\}` 连续重复字符至少m次，如：`o\{5,\}`匹配至少连续有5个 o 的行
- `\{m,n\}` 连续重复字符至少m次，不多于n次，如：`o\{5,10\}`匹配连续5-10个 o 的行

### 常用选项
1. `-n` : 同时显示匹配上下的n行. `grep -2 print test.py`
1. `-i` : 忽略大小写
1. `-s` : `--silent` 不显示 不存在/文件读取错误的信息
2. `-l` : 打印匹配表达式的文件清单
2. `-L` : 打印不匹配表达式的文件清单
3. `-v` : 反检索, 只显示不匹配的行

### 示例
1. `grep -rnlw --exclude-dir=vendor --exclude-dir=node_* --exclude=*.log 9000`
    - 解释: 在当前文件夹下查找所有包含 9000 这个单词的文件, 同时跳过 `vendor` 目录, `node_*` 目录, `.log` 文件
    - r 表示递归查找, 遍历所有子目录
    - `exclude` 表示不包含, 同理, `include` 表示只查找包含该规则的文件

## locate
> [参考链接](https://wiki.archlinux.org/index.php/Locale)

"find -name"的另一种写法, 但是不搜索具体目录, 而是搜索一个数据库（/var/lib/locatedb）, 这个数据库中含有本地所有文件信息. Linux系统自动创建这个数据库, 并且每天自动更新一次, 所以使用locate命令查不到最新变动过的文件. 为了避免这种情况, 可以在使用locate之前, 先使用updatedb命令, 手动更新数据库. 

## whereis
- whereis命令只能用于程序名的搜索, 而且只搜索二进制文件（参数-b）、man说明文件（参数-m）和源代码文件（参数-s）. 如果省略参数, 则返回所有信息. 
    - `whereis grep`

## which
- which命令的作用是, 在PATH变量指定的路径中, 搜索某个系统命令的位置, 并且返回第一个搜索结果. 也就是说, 使用which命令, 就可以看到某个系统命令是否存在, 以及执行的到底是哪一个位置的命令. 

## type
- 区分某个命令到底是由shell自带的, 还是由shell外部的独立二进制文件提供的
- 如果一个命令是外部命令, 那么使用-p参数, 会显示该命令的路径, 相当于which命令. 