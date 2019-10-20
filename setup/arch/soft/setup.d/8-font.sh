#!/bin/bash

function install(){
    echo "------------------------ 字体安装 -------------------------\n"
    sudo pacman -S --noconfirm -q wqy-microhei ttf-inconsolata ttf-font-awesome
    yay -S ttf-mac-fonts
    fc-cache -vf
}

install
