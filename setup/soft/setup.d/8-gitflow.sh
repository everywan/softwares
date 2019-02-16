#!/bin/bash

function install(){
    echo "------------------------ 安装 gitflow -------------------------\n"
    wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh
    sudo bash gitflow-installer.sh install stable
    rm gitflow-installer.sh
}

install
