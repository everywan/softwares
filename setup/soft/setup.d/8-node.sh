#!/bin/bash

function install(){
    echo "------------------------ node安装 -------------------------\n"
    sudo pacman -S --noconfirm npm
    npm config set registry https://registry.npm.taobao.org
}

install
