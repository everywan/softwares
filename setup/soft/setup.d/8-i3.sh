#!/bin/bash

function install(){
    echo "------------------------ i3安装 -------------------------\n"
    sudo pacman -S --noconfirm rofi
    yay -S i3 polybar
}

install
