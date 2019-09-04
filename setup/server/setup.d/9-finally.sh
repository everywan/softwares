#!/bin/bash

function install(){
    echo "------------------------ 收尾工作 -------------------------\n"
    git config --global user.name "wzs"
    git config --global user.email "zhensheng.five@gmail.com"
    git config --global url."git@github.com:".insteadOf "https://github.com/"
}

install
