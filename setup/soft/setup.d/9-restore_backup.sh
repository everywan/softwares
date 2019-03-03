#!/bin/bash

function install(){
    echo "------------------------ 恢复云端备份 -------------------------\n"

    # 首先判断 ossutil 配置文件是否存在
    # /usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur oss://cloud-cn/arch ~/cloud

    # ln -s ~/cloud/backup/config/xinitrc .xinitrc
    # ln -s ~/cloud/backup/config/xprofile .xprofile
    # ln -s ~/cloud/backup/config/zshrc .zshrc
    # ln -s ~/cloud/config/i3 .
    # ln -s ~/cloud/config/polybar .
    # ln -s ~/cloud/config/termite .
    # ln -s ~/cloud/config/rofi .
    # sudo cp ~/cloud/backup/config/shadowsocks /etc
    # sudo cp ~/cloud/backup/config/hosts /etc
}

install
