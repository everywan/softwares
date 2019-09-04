#!/bin/bash

function install(){
    echo "------------------------ 安装ftp -------------------------\n"
    sudo yum install vsftpd
    sudo systemctl start vsftpd.service
    sudo systemctl enable vsftpd.service
    # 配置文件在 /etc/vsftpd/vsftpd.conf, 根据需求更改即可
    # 默认端口21, 配置一般不需要改变
    # 因为 FTP 使用给定的 listen_port (默认为21)  仅用于命令, 所有的数据传输都是通过不同的端口完成的. 这些端口由 FTP 守护程序为每个会话随机选择 (也取决于是使用主动还是被动模式). 要告诉 iptables 应该接受端口上的数据包, 需要 nf_conntrack_ftp.
    # 参见 https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)
    # 配置文件参见 config/vsftp, 需要添加 /etc/vsftpd/chroot_list 以更改登录用户默认目录
}

install
