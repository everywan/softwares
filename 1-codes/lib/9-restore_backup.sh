#!/bin/bash

function install(){
    echo "------------------------ 恢复云端备份 -------------------------\n"

    # 首先判断 ossutil 配置文件是否存在
    # /usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur oss://cloud-cn/arch /data/cloud

    # i3
    # ln -s /data/cloud/config/rofi ~/.config/
    # ln -s /data/cloud/config/i3 ~/.config/
    # ln -s /data/cloud/config/polybar ~/.config/
    # ln -s /data/cloud/config/termite ~/.config/

    # ln -s /data/cloud/config/home/xinitrc ~/.xinitrc
    # ln -s /data/cloud/config/home/xprofile ~/.xprofile
    # ln -s /data/cloud/config/home/zshrc ~/.zshrc
    # ln -s /data/cloud/config/home/zprofile ~/.zprofile
    # ln -s /data/cloud/config/home/Xmodmap ~/.Xmodmap
    # ln -s /data/cloud/script ~/.config
    # sudo cp /data/cloud/config/home/config/hosts /etc
}

install
