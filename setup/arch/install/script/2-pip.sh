#!/bin/bash

function install(){
    echo "------------------------ 安装 pip  -------------------------\n"
    sudo python get-pip.py -i https://pypi.doubanio.com/simple/
    mkdir ~/.pip
    tee ~/.pip/pip.conf <<-'EOF'
[global]  
timeout = 6000  
index-url = https://pypi.doubanio.com/simple/  
[install]  
use-mirrors = true  
mirrors = https://pypi.doubanio.com/simple/ 
EOF
  
  sudo cp -r ~/.pip /root/
  sudo pacman -S ipython
}

install
