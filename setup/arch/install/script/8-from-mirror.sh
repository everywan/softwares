#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo pacman -S --noconfirm -q nmap tree expect tig
}

install
