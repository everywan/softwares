#!/bin/bash

function install(){
    echo "------------------------ sshd服务 -------------------------\n"
    sudo apt remove openssh-server
    sudo apt install openssh-server
    sudo service ssh start
}

install
