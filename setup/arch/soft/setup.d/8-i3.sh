#!/bin/bash

function install(){
    echo "------------------------ i3安装 -------------------------\n"
    sudo pacman -S --noconfirm -q jsoncpp rofi
    # TODO 需要输入
    # yay -S i3 polybar
}

install
