#!/bin/bash

function install(){
    echo "------------------------ 安装 go -------------------------\n"
    wget -c https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz -O go.tar.gz
    tar -xzf go.tar.gz && sudo mv go /usr/local/src && sudo ln -s /usr/local/src/go/bin/go /usr/local/bin/go
    rm go.tar.gz
}

install
