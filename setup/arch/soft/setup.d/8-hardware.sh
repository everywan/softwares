#!/bin/bash

function install(){
    echo "------------------------ 声卡配置 -------------------------\n"
    sudo pacman -S --noconfirm alsa-utils
    sudo gpasswd -a wzs audio

    echo "------------------------ 蓝牙配置 -------------------------\n"
    sudo pacman -S --noconfirm blueman
}

install
