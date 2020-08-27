#!/bin/bash

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    sudo apt update
    sudo apt install -y python openssh-server vim wget curl rsync git
    sudo apt install -y nmap tree zsh

    # 可选. tig: git cli可视化
    sudo apt install tig

    if [ $(isInstall zsh) == NOT_INSTALL ];then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    echo "安装ss"
    if [ $(isInstall sslocal) == NOT_INSTALL ];then
        install_shadowsock
    fi
    
    echo "安装pip && 配置豆瓣源"
    if [ $(isInstall pip) == NOT_INSTALL ];then
        install_pip
    fi

    echo "安装ossutil"
    if [ $(isInstall ossutil) == NOT_INSTALL ];then
        install_ossutil
    fi

    echo "安装Go, 版本 1.11.2"
    if [ $(isInstall go) == NOT_INSTALL ];then
        wget -c https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz -O go.tar.gz
        tar -xzf go.tar.gz && sudo mv go /usr/local/src && sudo ln -s /usr/local/src/go/bin/go /usr/local/bin/go
    fi

    # git flow
    wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh && sudo bash gitflow-installer.sh install stable; rm gitflow-installer.sh
}

# 判断是否安装
function isInstall(){
    if [ -x "$(command -v $1)" ]; then
        echo INSTALLED
    else
        echo NOT_INSTALL
    fi
}

function install_shadowsock(){
    # 使用 sslocal 管理, 可以作为服务端
    git clone https://github.com/shadowsocks/shadowsocks.git
    pushd shadowsocks
    git checkout origin/master -b master
    sudo python setup.py install
    popd
}

function install_pip(){
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    sudo python get-pip.py -i https://pypi.doubanio.com/simple/
    mkdir ~/.pip
    tee ~/.pip/pip.conf <<-'EOF'
[global]  
timeout = 6000  
index-url = https://pypi.doubanio.com/simple/  
[install]  
use-mirrors = true  
mirrors = https://pypi.doubanio.com/simple/ 
EOF
}

function install_ossutil(){
    wget -c http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1524643963683/ossutil64\?spm\=a2c4g.11186623.2.11.3638779cVMqV6m
    sudo mv ossutil64\?spm=a2c4g.11186623.2.11.3638779cVMqV6m /usr/local/bin/ossutil
}

if [ ! -d "/tmp/install_aaa" ]; then
    mkdir -p /tmp/install_aaa
else
    sudo rm -rf /tmp/install_aaa/*
fi
pushd /tmp/install_aaa

main

popd