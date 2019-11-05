#!/bin/bash

function install(){
    echo "------------------------ dwm安装 -------------------------\n"
    git clone http://github.com/everywan/dwm
    sudo pacman -S --noconfirm -q tilda
}

install
