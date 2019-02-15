#!/bin/bash

function backup(){
    # 备份系统, 恢复系统只需要换下 文件夹顺序就行了 
    rsync -arpogv /* /backup/backup --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/backup/*}
    # 备份权限(需要先安装 acl)
    getfacl -R / > /backup/backup_permissions.txt
    # 压缩备份
    tar -jcvf /backup/backup.tar.bz2 /backup/backup /backup/backup_permissions.txt
    # 恢复权限
    # setfacl --restore=backup_permissions.txt
}

backup()
