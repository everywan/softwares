#!/bin/bash

function install(){
    echo "------------------------ 恢复云端备份 -------------------------\n"

    # 首先判断 ossutil 配置文件是否存在
    # /usr/local/bin/ossutil -e oss-cn-beijing.aliyuncs.com cp -fur oss://cloud-cn/arch ~/cloud

    # ln -s ~/cloud/backup/config/xinitrc ~/.xinitrc
    # ln -s ~/cloud/backup/config/xprofile ~/.xprofile
    # ln -s ~/cloud/backup/config/zshrc ~/.zshrc
    # ln -s ~/cloud/backup/config/Xmodmap ~/.Xmodmap
    # ln -s ~/cloud/backup/script ~/.config
    # ln -s ~/cloud/config/i3 ~/.config/
    # ln -s ~/cloud/config/polybar ~/.config/
    # ln -s ~/cloud/config/termite ~/.config/
    # ln -s ~/cloud/config/rofi ~/.config/
    # sudo ln -s ~/cloud/backup/config/hosts /etc
    # sudo ln -s ~/cloud/backup/script/backlight /usr/local/bin
    # sudo ln -s ~/cloud/backup/script/fpay_mysql /usr/local/bin
}

install
