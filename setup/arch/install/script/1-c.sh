#!/bin/bash

function install(){
    echo "------------------------ 安装 c 扩展 -------------------------\n"
    sudo pacman -S clang
}

install
