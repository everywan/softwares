#!/bin/bash

function install(){
    echo "------------------------ windows server 管理 -------------------------\n"
    sudo pacman -Sy rdesktop
    # 连接示例
    # rdesktop -g 1920x1080 -d pc -u wzs 192.168.31.169:3389
}

install
