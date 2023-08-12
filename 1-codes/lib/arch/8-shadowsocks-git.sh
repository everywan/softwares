#!/bin/bash

function old_install(){
    # 参考 /soft/shadowsocks.md
    echo "------------------------ shadowsocks -------------------------\n"
    sudo pacman -S --noconfirm -q shadowsocks
}

install
