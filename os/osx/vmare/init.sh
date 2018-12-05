#!/bin/bash
set -x
set -e

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    sudo yum update
    sudo yum install vim git tree nmap wget curl -y

    if [ $(isInstall zsh) == NOT_INSTALL ];then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    echo "安装pip && 配置豆瓣源"
    install_pip

    echo "安装docker"
    install_docker

    echo "安装privoxy"
    install_privoxy

    echo "安装Go, 版本 1.11.2"
    wget -c https://dl.google.com/go/go1.11.2.darwin-amd64.tar.gz -O go.tar.gz
    tar -xzf go.tar.gz && mv go /usr/local/Cellar/ && ln -s /usr/local/Cellar/go/bin/go /usr/local/bin/go
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

function install_privoxy(){
    wget -c http://www.silvester.org.uk/privoxy/source/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz -O privoxy.tar.gz
    # 安装依赖命令
    sudo yum install autoconf -y
    sudo yum install gcc -y
    
    tar -xzf privoxy.tar.gz
    pushd privoxy-3.0.26-stable
    # 不要直接使用make命令, 不然生成只有可执行文件. 按照官方另一个教程一步步走, 直接make坑死.
    sudo useradd -g privoxy -s /sbin/nologin -M privoxy
    autoheader
    autoconf
    ./configure
    make
    make -n install
    sudo make -s install
    sudo cp ./privoxy.service /etc/systemd/system/multi-user.target.wants/
    popd
}

if [ $(basename "$0") == "init.sh" ]; then
    if [ ! -d "/tmp/install_aaa" ]; then
        mkdir -p /tmp/install_aaa
    else
        sudo rm -rf /tmp/install_aaa/*
    fi
    pushd /tmp/install_aaa

    main

    popd
fi
