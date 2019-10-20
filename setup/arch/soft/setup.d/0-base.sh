#!/bin/bash

function install(){
    echo "------------------------ 基础组件安装 -------------------------\n"
    sudo pacman -Syu --noconfirm -q
    sudo pacman -S --noconfirm -q openssh gvim wget curl rsync git
}

install
