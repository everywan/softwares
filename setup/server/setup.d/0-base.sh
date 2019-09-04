#!/bin/bash

function install(){
    echo "------------------------ 基础组件安装 -------------------------\n"
    sudo yum update -y
    sudo yum install -y gvim wget curl rsync git
}

install
