#!/bin/bash
set -x
set -e

readonly INSTALLED="install"
readonly NOT_INSTALL="not_install"
readonly WORK_DIR=`dirname $0`

function main(){
    # osx 上超级好用的包管理器
    if [ $(isInstall brew) == NOT_INSTALL ];then
        install_brew
    fi

    # 常用基础软件包
    brew install git tree wget curl mycli tig

    install_go

    # osx 上超级好用的终端
    brew install --cask iterm2

    # 文本编辑器 vscode， 可按需更换为自己喜欢的编辑器。
    brew install --cask visual-studio-code

    # god use vpn
    # brew install shadowsocks-libev
    # brew services start shadowsocks-libev

    if [ $(isInstall zsh) == NOT_INSTALL ];then
        brew install zsh
        # oh my zsh
        git clone https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git
        pushd ohmyzsh/tools
        REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh
        popd
    fi

    # spacevim 超级好用的 vim 扩展
    install_spacevim

    # echo "安装pip && 配置豆瓣源"
    # install_pip

    # local caskInstall=`brew list --cask`

    git config --global user.name "wzs"
    git config --global user.email "zhensheng.five@gmail.com"
    git config --global url."git@github.com:".insteadOf "https://github.com/"
}

# 判断是否安装
function isInstall(){
    if [ -x "$(command -v $1)" ]; then
        echo INSTALLED
    else
        echo NOT_INSTALL
    fi
}

# 从中科大源安装, 参考 https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
function install_brew(){
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    /bin/bash brew-install/install.sh
    rm -rf brew-install

    echo 'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"' >> ~/.zprofile
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.zprofile
    source ~/.zprofile
    brew update
}

function install_go(){
    brew install go

    export GOPROXY=https://mirrors.aliyun.com/goproxy/
    go get github.com/cweill/gotests/gotests
    go get github.com/fatih/gomodifytags
    go get github.com/josharian/impl
    go get github.com/haya14busa/goplay/cmd/goplay
    go get github.com/go-delve/delve/cmd/dlv
    go get honnef.co/go/tools/cmd/staticcheck
    go get golang.org/x/tools/gopls
    
    brew install protobuf
    go get -u github.com/golang/protobuf/protoc-gen-go
}

function install_spacevim(){
    curl -sLf https://spacevim.org/install.sh | bash
    # 输入法自动切换命令行插件。vim切换需要此插件。
    brew install fselect im-select
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
