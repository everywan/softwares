#!/bin/bash

function install(){
    echo "------------------------ 安装 分享类工具  -------------------------\n"
    # nodeppt, 解析 markdown 为 ppt 方式
    sudo npm install -g nodeppt --registry=https://registry.npm.taobao.org

    # hfs, http file system, 将本地文件映射到http上 
}

install
