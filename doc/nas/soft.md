# NAS软件配置
主要分为 系统选择 和 软件安装 两方面

---
nas系统选择如下
1. 成品nas
  - 群晖 qc 不稳定
  - 不支持 ssh/包管理 等, 非完全linux
  - 性能弱, 价格还高
2. exsi:
  - exsi 最大的好处是提供虚拟化. 如果不考虑 性能损耗/体积/噪音 的问题, 我还是挺喜欢用的. 目前 nas 不用 exsi, 一方面是 性能/体积/噪音 的限制, 另一方面就是 centos/winserver 已经满足了需求.
3. win server: 使用 winserver 最大的原因是, 迅雷.  winserver 功能方面没什么问题, 其实还更强.
  - 兼容性更好, 如 j3455 的板子, linux 内核必须在 4.8 以上才能正常使用.
  - win/linux/android/ios 都可以通过 远程桌面/ssh 两种方式管理服务器
  - win 上软件更多
  - 缺点就是, 对性能要求高了一些, 使用习惯有些不一样(wsl毕竟不是真正的linux).
4. centos: 不使用迅雷, 就安装 centos. 我还是习惯使用 centos
5. 当然, 不差钱的话,可以考虑 云服务器+OSS+大带宽

目前而言, 想用 exsi/winserver 的原因, 就是迅雷... 很多资源只能通过迅雷下载, 即使使用其他机器下载, 内网传输也是很麻烦, 所以还是尽量在 nas 上下载. 所以, 只有 exsi/winserver 两种方案.

等以后有自己的房子了, 有自己的机房了, 可以考虑搞个NB服务器, 整个 exsi.

----
nas软件主要分为以下方面
1. 文件传输
2. 多媒体串流
3. 下载器
4. 内网穿透

## 文件传输
数据传输可以使用 云盘软件, 也可以使用 各种文件传输协议实现.

### 文件服务器
可以使用文件服务器实现云盘的文件传输功能.
涉及关键字: 分布式文件系统, 文件传输, 文件共享

smb(Server Message Block): 网络文件共享系统(Common Internet File System), 可以使网络上(一般指局域网)的机器共享 文件/打印机/串行端口 等资源, 提供认证功能.
- 适合局域网资源共享, 文件共享
- [what is smb](https://www.samba.org/cifs/docs/what-is-smb.html)

ftp(File Transfer Protocol): 用于在互联网上进行文件传输, 基于 TCP/IP 协议. 一般而言, 我们使用 sftp/ftps 以实现认证功能
- 适合文件传输

NFS(Network File System): 网络文件系统, 由 sun公司(已故) 开发, 追求客户端像访问本地文件一样访问服务器文件.
- NFS 系统 可由 `/etc/fstab` 自动挂载

Upnp(Universal Plug and Play): 通用即插即用协议, 目标是 使家庭网络和公司网络的各种设备能够无缝链接.
- DLNA(Digital Living Network Alliance) 是 Upnp 的一套成熟的解决方案, 由 sony/intel/microsoft 等公司发起成立, 用于解决 个人PC/Mobile/TV 等设备在无线网络/有线网络的互联互通.
- 一般用于 局域网内的 多媒体共享, 如手机投影到电视. 并不适用与文件服务器, 此处只是介绍了解一下


一般而言, 推荐使用 ftp 或 smb. ftp 适合纯文件传输, smb 适合多功能(资源浏览+文件传输). 详细不同点如下
1. 云端文件查看
  - smb 协议下, 客户端可以直接查看服务器上的文件内容, 无需下载.
  - ftp 只是文件传输协议, 只能下载后查看
2. 适用场景
  - smb 一般用于局域网内的传输, 如 kodi 通过 smb 串流视频内容, 同时可以 上传/下载 文件.
  - ftp 只是文件传输协议, 用于 上传/下载 文件, 需要下载后才能查看.

对于 windows, 更简单的文件共享方式就是 右键文件夹, 选择共享, 就可以在 局域网 上找到该机器/文件了.

### 云盘
云盘有几种方案
1. 使用现有的商业方案, 此处推荐坚果云, 收费但是价格/速度都还可以.
2. 使用开源方案, 需要自备服务器. 推荐 阿里/腾讯云ECS, 搭配 NextCloud 或 Syncthing.
  - NextCloud 功能上更像传统云盘, 而 Syncthing 主要用于个设备文件同步
3. 自己开发, 借助 oss/ecs 存储数据, 借助 fsync/upload 传输数据, 借助 inotify 监听文件更改(仅限linux).
  - oss存在的问题是, 当时用 ossutil 上传数据时, 并非同步, 只是更新. 新增/更改的文件会被同步, 但是删除的文件在云端不会被删除.

[NextCloud-docker](https://github.com/nextcloud/docker): 与正常云盘功能类似, 可以同步照片, 通讯录等. 全平台支持, linux界面比较老.

[Syncthing](https://github.com/syncthing/syncthing): 注重各设备之间的文件同步, 全平台支持, 使用Go语言编写.

arch 下可使用 incron 命令监听数据, 或者借助 inotify api 自己写程序监听. inotify 更多信息参考 `man inotify`

ecs rsync 同步命令:
```Bash
rsync -qarP -pog --timeout=60 /data/cloud wzs@default:/home/wzs/
```

ossutil 同步命令:
```Bash
/usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur /data/cloud/ oss://cloud
```

## 多媒体串流
推荐 PLEX, 付费软件.

用过 群晖的 vedio station, 不好用, 很多资源无法解码, 功能也少, 还是推荐plex

## 下载器

Linux 下载软件建议 aria2/qbittorrent, 开放相关端口即可远程访问, 支持webui, 使用docker安装即可.
- [aria2](/setup/soft/options/aria2)
- [qbittorrent](/setup/soft/options/qbittorrent)

或者安装 exsi/winserver, 使用迅雷下载

---
PS: 但是, 某些资源, 如电影, 用这俩下载还是很累的.

至于为什么不买正版... 你倒是给我提供正版网站啊... 我买了腾讯会员, 生化危机你让我看 1-5, 第六集你告诉我版权在 爱奇异 手里, 我还的买其他会员, 还的切换软件, 还的一个个去找? 丢你老母!

自己动手, 丰衣足食.

另外, 下载器不止可以下载这些, 还可以下载一些公共资源什么的, 如学习资料等等一切要保存到云盘的数据.

---

种子下载原理自行搜索

## 内网穿透

方案一: 使用 frp/autossh 等软件, 仅需一台有公网IP的服务器即可. 同时可实现 p2p 连接, 从而在传文件时不走服务器.
- 实现: 局域网机器通过 autossh/frp 将端口映射到远程服务器, 然后外网就可以通过该端口访问局域网机器.
- 缺点: 比较以来公网服务器的带宽. 外网与局域网通信需要经过公网服务器中转. 考虑到当公网服务器不稳定时, 局域网需要启动守护进程保证链接持续.
- 参考 [端口映射](/doc/port-mapping.md)

方案二: 使用 ddns, 需要域名, 以及局域网是公网IP(可以是动态分配的).
- 实现: 在路由器上查找 ddns 功能(一般在 `应用` 中), 然后根据提示设置即可.

ddns 介绍: 一种自动更新名称服务器的技术, 根据互联网的域名订立规则, 域名必须跟从固定的IP地址. 但动态DNS系统为动态网域提供一个固定的名称服务器(Name server), 透过即时更新, 使外界用户能够连上动态用户的网址.

p2p穿透, 种子文件 原理详解: [地址](/doc/port-mapping.md)
