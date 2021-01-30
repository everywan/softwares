#!/bin/bash

function install(){
    echo "------------------------ 安装 oh-my-zsh -------------------------\n"
    sudo yum install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install
