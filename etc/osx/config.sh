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

    # 阿里源包不齐全，所以还是用ustc的比较合适
    # 替换 Homebrew
    git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
    # 替换 Homebrew Core
    git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
    # 替换 Homebrew Cask
    git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
    brew update
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zprofile
    source ~/.zprofile

    brew install git tree wget curl mycli

    if [ $(isInstall zsh) == NOT_INSTALL ];then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    brew cask install iterm2
    brew cask install visual-studio-code

    brew install shadowsocks-libev
    brew services start shadowsocks-libev

    # spacevim:
    curl -sLf https://spacevim.org/install.sh | bash

    # oh my zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    brew tap homebrew/cask-fonts
    # spacevim 图标字体
    brew cask install font-hack-nerd-font

    echo "安装pip && 配置豆瓣源"
    install_pip

    echo "安装Shadowsocks"
    install_shadowsock

    # 输入法自动切换命令行插件。vim切换需要此插件。
    curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh
    

    echo "安装Go, 版本 1.11.2"
    wget -c https://dl.google.com/go/go1.11.2.darwin-amd64.tar.gz -O go.tar.gz
    tar -xzf go.tar.gz && mv go /usr/local/Cellar/ && ln -s /usr/local/Cellar/go/bin/go /usr/local/bin/go

    local caskInstall=`brew cask list`

    # 判断是否安装 -z string长度为0且为真， 参考 http://docs.linuxtone.org/ebooks/C&CPP/c/ch31s05.html
    if [ -z $(echo $caskInstall | grep -wo iterm2) ];then
        # 安装 iterm2, 后续导入 ./iterm2.json 配置文件即可还原配置
        brew cask install iterm2
    fi

    brew install go
    # 设置goroot。brew安装的软件包在 /usr/local/Cellar/go/{version}/libexec，不清楚为什么这么搞。
    # 不应该放在 /usr/local/src 下么，而且应该设置个软连接，然后其他的地方都用软连接么？这么着版本一变不全都乱套了吗？
    # export GOROOT='/usr/local/Cellar/go/{version}/libexec'
    # 安装必要软件包。简单的方法是打开vscode，会自动推荐你安装那些软件
    go get github.com/mdempsky/gocode
    go get github.com/uudashr/gopkgs/v2/cmd/gopkgs
    go get github.com/ramya-rao-a/go-outline
    go get github.com/rogpeppe/godef
    go get github.com/sqs/goreturns
    go get golang.org/x/lint/golint
    go get golang.org/x/tools/gopls
    go get golang.org/x/tools/cmd/goimports

    brew install protobuf
    go get -u github.com/golang/protobuf/protoc-gen-go

    git config --global user.name "wzs"
    git config --global user.email "zhensheng.five@gmail.com"
    git config --global url."git@github.com:".insteadOf "https://github.com/"

    # brew cask install alfred
    brew install npm
    npm config set registry https://registry.npm.taobao.org
    npm install -g @vue/cli
}

# 判断是否安装
function isInstall(){
    if [ -x "$(command -v $1)" ]; then
        echo INSTALLED
    else
        echo NOT_INSTALL
    fi
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
