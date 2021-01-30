#!/bin/bash

function install(){
    echo "------------------------ 安装 go -------------------------\n"
    sudo yum install golang.x86_64
    # wget -c https://golang.org/dl/go1.15.7.linux-amd64.tar.gz -O go.tar.gz
    # tar -xzf go.tar.gz && sudo mv go /usr/local/src && sudo ln -s /usr/local/src/go/bin/go /usr/local/bin/go
    # rm go.tar.gz
}

install
