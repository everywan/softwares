#!/bin/bash

function install(){
    echo "------------------------ 安装 go -------------------------\n"
    sudo pacman -S --noconfirm -q go go-tools
    # export GOPROXY=https://mirrors.aliyun.com/goproxy/   # 设置代理
    # export GOPRIVATE=github.com/evenyun    # 设置私有仓库, 多个使用 `,` 分割
}

install
