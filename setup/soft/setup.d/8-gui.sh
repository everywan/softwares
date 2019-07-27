#!/bin/bash

function install(){
    sudo pacman -S --noconfirm xorg xorg-xinit termite compton
    # feh 用于设置壁纸, scrot 用于捕获屏幕镜像, 在锁屏时使用
    sudo pacman -S --noconfirm feh scrot
}

install
