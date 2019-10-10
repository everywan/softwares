#!/bin/bash

function install(){
    echo "------------------------ 基础组件安装 -------------------------\n"
    sudo yum update
    sudo yum install -y openssh gvim wget curl rsync git
}

install
