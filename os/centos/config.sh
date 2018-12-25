#!/bin/bash
set -x
set -e

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    sudo yum update
    sudo yum install vim git tree nmap wget curl zsh rsync openssh -y

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    echo "安装pip && 配置豆瓣源"
    if [ $(isInstall pip) == NOT_INSTALL ];then
        install_pip    
    fi
    
    echo "安装docker"
    if [ $(isInstall docker) == NOT_INSTALL ];then
        install_docker    
    fi

    echo "安装ossutil"
    if [ $(isInstall ossutil) == NOT_INSTALL ];then
        install_ossutil    
    fi

    echo "安装Go, 版本 1.11.2"
    if [ $(isInstall go) == NOT_INSTALL ];then
        wget -c https://dl.google.com/go/go1.11.2.darwin-amd64.tar.gz -O go.tar.gz
        tar -xzf go.tar.gz && mv go /usr/local/src/ && ln -s /usr/local/src/go/bin/go /usr/local/bin/go    
    fi
}

# 判断是否安装
function isInstall(){
    if [ -x "$(command -v $1)" ]; then
        echo INSTALLED
    else
        echo NOT_INSTALL
    fi
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

function install_ossutil(){
    wget -c http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1524643963683/ossutil64\?spm\=a2c4g.11186623.2.11.3638779cVMqV6m
    sudo mv ossutil64\?spm=a2c4g.11186623.2.11.3638779cVMqV6m /usr/local/bin/ossutil
}

if [ $(basename "$0") == "config.sh" ]; then
    if [ ! -d "/tmp/install_aaa" ]; then
        mkdir -p /tmp/install_aaa
    else
        sudo rm -rf /tmp/install_aaa/*
    fi
    pushd /tmp/install_aaa

    main

    popd
fi
