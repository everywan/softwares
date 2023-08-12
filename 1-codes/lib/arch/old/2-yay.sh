#!/bin/bash

# 新系统已经集成了 yay

function install(){
    echo "------------------------ 安装 yay -------------------------\n"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si
    popd
}

install
