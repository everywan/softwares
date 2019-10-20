#!/bin/bash

function install(){
    echo "------------------------ 安装 oh-my-zsh -------------------------\n"
    sudo pacman -S --noconfirm -q zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install
