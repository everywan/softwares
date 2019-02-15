#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo pacman -S --noconfirm nmap ydcv tree expect
    sudo pacman -S --noconfirm code chromium guake tig trash-put shadowsocks

    # notebook
    # [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)
    sudo pacman -S --noconfirm tlp
}

install()
