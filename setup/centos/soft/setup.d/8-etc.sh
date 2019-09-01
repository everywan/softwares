#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo yum install -y nmap tree expect tig
    sudo yum install -y trash-cli

    # notebook
    # [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)
    git config --global user.name "wzs"
    git config --global user.email "zhensheng.five@gmail.com"

    # 更改主机名称
    sudo hostnamectl set-hostname nas
}

install
