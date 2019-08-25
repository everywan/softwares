#!/bin/bash

function install(){
    echo "------------------------ 安装 protobuf -------------------------\n"
    # 源代码安装参考 http://github.com/google/protobuf
    sudo pacman -S --noconfirm protobuf
    # 安装 protoc-Go 工具
    go get -u github.com/golang/protobuf/protoc-gen-go
}

install
