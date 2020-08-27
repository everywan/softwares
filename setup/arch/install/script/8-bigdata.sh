#!/bin/bash

function install(){
    echo "------------------------ jupyter安装 -------------------------\n"
    # readline: ipython命令补全
    sudo pip install readline
    sudo pip install numpy pandas pyspark
    sudo pip install seaborn
}

install
