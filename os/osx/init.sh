#!/bin/bash
set -x
set -e

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    if [ $(isInstall brew) == NOT_INSTALL ];then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install git tree wget curl ydcv mycli -y

    if [ $(isInstall zsh) == NOT_INSTALL ];then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    echo "下载github项目"
    mkdir ~/git && git clone https://github.com/everywan/note.git ~/git/note

    echo "安装pip && 配置豆瓣源"
    install_pip

    echo "安装Shadowsocks"
    install_shadowsock

    echo "安装Go, 版本 1.11.2"
    wget -c https://dl.google.com/go/go1.11.2.darwin-amd64.tar.gz -O go.tar.gz
    tar -xzf go.tar.gz && mv go /usr/local/Cellar/ && ln -s /usr/local/Cellar/go/bin/go /usr/local/bin/go

    local caskInstall=`brew cask list`

    # 判断是否安装 -z string长度为0且为真， 参考 http://docs.linuxtone.org/ebooks/C&CPP/c/ch31s05.html
    if [ -z $(echo $caskInstall | grep -wo iterm2) ];then
        # 安装 iterm2, 后续导入 ./iterm2.json 配置文件即可还原配置
        brew cask install iterm2
    fi

    if [ -z $(echo $caskInstall | grep -wo hyperswitch) ];then
        # 安装切换插件, cmd+tab 可以在多窗口间切换, [如何更改为 cmd+tab 切换](https://sspai.com/post/38838)
        brew cask install hyperswitch
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

function install_shadowsock(){
    git clone https://github.com/shadowsocks/shadowsocks.git
    pushd shadowsocks
    git checkout origin/master -b master
    sudo python setup.py install
    popd
    alias sslst='sudo sslocal -c $1 -d $2'
}

function install_pip(){
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    sudo python get-pip.py
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
