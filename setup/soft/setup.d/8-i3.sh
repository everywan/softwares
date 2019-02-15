#!/bin/bash

function install(){
    echo "------------------------ i3安装 -------------------------\n"
    sudo pacman -S --noconfirm xorg xorg-xinit termite feh rofi scrot imagemagic compton
    yay -S i3 polybar
}

install()
