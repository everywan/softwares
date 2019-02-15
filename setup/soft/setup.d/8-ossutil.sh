#!/bin/bash
# [文档](https://help.aliyun.com/document_detail/50452.html)

function install(){
    echo "------------------------ 安装 ossutil -------------------------\n"
    wget -c http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1524643963683/ossutil64\?spm\=a2c4g.11186623.2.11.3638779cVMqV6m
    sudo mv ossutil64\?spm=a2c4g.11186623.2.11.3638779cVMqV6m /usr/local/bin/ossutil
}

install()
