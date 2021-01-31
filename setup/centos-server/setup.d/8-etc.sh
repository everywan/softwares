#!/bin/bash

function install(){
    echo "------------------------ 从源安装的一些软件 -------------------------\n"
    sudo yum install -y nmap tree expect tig supervisor
    
    sudo systemctl start supervisord.service
    sudo systemctl enable supervisord.service

    # notebook
    # [参考官方文档](https://linrunner.de/en/tlp/docs/tlp-configuration.html)
}

install
