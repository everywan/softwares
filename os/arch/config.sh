#!/bin/bash
set -x
set -e

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    sudo pacman -Syu
    sudo pacman -S openssh vim wget curl rsync git
    sudo pacman -S nmap ydcv tree privoxy zsh expect autossh
    sudo pacman -S code chromium

    sudo systemctl start sshd
    sudo systemctl enable sshd
    # autossh 自动反向代理, 注意 需要先使用ssh登录过, 并且是免密登录
    # 配置参考: https://github.com/everywan/note/blob/d1ca2a7753e447e480107d037237a34a5cadf583/application/os/linux/basic_cmd.md
    # sudo systemctl start autossh
    # sudo systemctl enable autossh

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

    echo "安装docker"
    if [ $(isInstall docker) == NOT_INSTALL ];then
        install_docker    
    fi

    echo "安装aurman"
    if [ $(isInstall aurman) == NOT_INSTALL ];then
        install_aurman    
    fi

    echo "安装ossutil"
    if [ $(isInstall ossutil) == NOT_INSTALL ];then
        install_ossutil    
    fi

    echo "安装Go, 版本 1.11.2"
    if [ $(isInstall go) == NOT_INSTALL ];then
        wget -c https://dl.google.com/go/go1.11.2.darwin-amd64.tar.gz -O go.tar.gz
        tar -xzf go.tar.gz && sudo mv go /usr/local/src && sudo ln -s /usr/local/src/go/bin/go /usr/local/bin/go    
    fi

    # 选择安装: TLP:电池管理, trash-put: 回收站
    sudo pacman -S tlp trash-put

    # deepin截图软件
    aurman -S deepin-screenshot

    # mysql客户端(mycli)
    aurman -S mycli

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
    git clone https://github.com/shadowsocks/shadowsocks.git
    pushd shadowsocks
    git checkout origin/master -b master
    sudo python setup.py install
    # use systemctl start ss
    # systemctl start shadowsocks@config
    popd
}

function install_docker(){
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    echo "配置docker免sudo"
    sudo usermod -aG docker ${USER}
    echo "需要重新登入终端, user 才可以使用docekr组的权限"
    
    echo "配置docker加速器"
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": ["https://pfonbmyi.mirror.aliyuncs.com"]
}
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
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

function install_aurman(){
    git clone https://aur.archlinux.org/aurman.git
    pushd aurman
    # 导入gpg
    gpg --recv-keys 465022E743D71E39
    makepkg -si
    popd
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

# if [ $(basename "$0") == "config.sh" ]; then
# fi