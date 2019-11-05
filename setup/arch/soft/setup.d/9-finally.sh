#!/bin/bash

function install(){
    echo "------------------------ 收尾工作 -------------------------\n"
    sudo systemctl start sshd
    sudo systemctl enable sshd
}

install
