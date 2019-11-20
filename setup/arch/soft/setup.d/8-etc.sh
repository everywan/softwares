#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo pacman -S --noconfirm -q nmap tree expect tig
    sudo pacman -S --noconfirm -q code chromium tig trash-cli shadowsocks
    # shadowsocks need copy.
    # vim 风格的 pdf 阅读器, a/s 控制按宽度/高度适配, +/- 缩放
    sudo pacman -S --noconfirm -q zathura zathura-pdf-poppler 

    # notebook
    # [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)
    sudo pacman -S --noconfirm -q tlp
    git config --global user.name "wzs"
    git config --global user.email "zhensheng.five@gmail.com"
}

install
