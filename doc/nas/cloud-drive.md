# 云盘

云盘有几种方案
1. 使用现有的商业方案, 此处推荐坚果云, 收费但是价格/速度都还可以.
2. 使用开源方案, 需要自备服务器. 推荐 阿里/腾讯云ECS, 搭配 NextCloud 或 Syncthing.
  - NextCloud 功能上更像传统云盘, 而 Syncthing 主要用于个设备文件同步
3. 自己开发, 借助 oss/ecs 存储数据, 借助 fsync/upload 传输数据, 借助 inotify 监听文件更改(仅限linux).

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


