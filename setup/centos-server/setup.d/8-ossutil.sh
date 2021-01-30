#!/bin/bash
# [文档](https://help.aliyun.com/document_detail/50452.html)

function install(){
    echo "------------------------ 安装 ossutil -------------------------\n"
    wget -c https://gosspublic.alicdn.com/ossutil/1.7.1/ossutil64?spm=a2c4g.11186623.2.7.65aa7385LgATPP -o ossutil
    sudo mv ossutil /usr/local/bin/ossutil
}

install
