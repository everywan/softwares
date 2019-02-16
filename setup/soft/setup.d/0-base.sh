#!/bin/bash

function install(){
    echo "------------------------ 基础组件安装 -------------------------\n"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm openssh gvim wget curl rsync git
}

install
