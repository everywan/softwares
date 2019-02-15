#!/bin/bash

function install(){
    echo "------------------------ 安装 yay -------------------------\n"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si
    popd
}

install()
