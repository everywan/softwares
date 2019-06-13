#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo pacman -S --noconfirm nmap tree expect tig
    sudo pacman -S --noconfirm code chromium guake tig trash-cli shadowsocks
    sudo pacman -S --noconfirm shadowsocks
    # shadowsocks need copy.
    # vim 风格的 pdf 阅读器, a/s 控制按宽度/高度适配, +/- 缩放
    sudo pacman -S --noconfirm zathurazathura-pdf-poppler 

    # notebook
    # [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)
    sudo pacman -S --noconfirm tlp
}

install
