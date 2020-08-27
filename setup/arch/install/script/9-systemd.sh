#!/bin/bash

# services 相关, 开机自启动服务

function install(){
    echo "------------------------ 收尾工作 -------------------------\n"
    sudo systemctl start sshd
    sudo systemctl enable sshd
}

install
