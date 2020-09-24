#!/bin/bash

function install(){
    echo "------------------------ cron安装 -------------------------\n"
    sudo pacman -S --noconfirm -q cronie
    sudo systemctl start cronie.service
    sudo systemctl enable cronie.service
}

install
