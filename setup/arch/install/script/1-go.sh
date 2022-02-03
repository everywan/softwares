#!/bin/bash

function install(){
    echo "------------------------ 安装 go -------------------------\n"
    sudo pacman -S --noconfirm -q go go-tools
}

install
