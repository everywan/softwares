#!/bin/bash

# --------------------------------------------------prepare work--------------------------------------------
mkdir /tmp/temp
pushd /tmp/temp

# --------------------------------------------------basic tool------------------------------------------------
# basic tools
sudo pacman -S openssh vim wget curl rsync git
sudo pacman -S nmap ydcv tree vscode chromium privoxy zsh expect

# tools setting
# sudo systemctl start sshd
# sudo systemctl enable sshd

# install oh my zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`

# --------------------------------------------------function------------------------------------------------
function install_shadowsock(){
    git clone https://github.com/shadowsocks/shadowsocks.git
    pushd shadowsocks
    git checkout origin/master -b master
    sudo python setup.py install
    # use systemctl start ss
    # systemctl start shadowsocks@config
    popd
}

function install_docker(){    
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    echo "配置docker免sudo"
    sudo usermod -aG docker ${USER}
    echo "需要重新登入终端, user 才可以使用docekr组的权限"
    
    echo "配置docker加速器"
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": ["https://pfonbmyi.mirror.aliyuncs.com"]
}
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

function install_pip(){
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
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
}

function install_aurman(){
    git clone https://aur.archlinux.org/aurman.git
    pushd aurman
    # 导入gpg
    gpg --recv-keys 465022E743D71E39
    makepkg -si
    popd
}

function install_ossutil(){
    wget -c http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1524643963683/ossutil64\?spm\=a2c4g.11186623.2.11.3638779cVMqV6m
    sudo mv ossutil64\?spm=a2c4g.11186623.2.11.3638779cVMqV6m /usr/local/bin/ossutil
}

function install_go(){
    wget -c https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz -O go.tar.gz
    tar -xzf go.tar.gz && mv go /usr/local/src && ln -s /usr/local/src/go/bin/go /usr/local/bin/go
}


# --------------------------------------------------adv tools------------------------------------------------
# 选择安装: TLP:电池管理, trash-put: 回收站
sudo pacman -S tlp trash-put

# deepin截图软件
aurman -S deepin-screenshot

# mysql客户端(mycli)
aurman -S mycli

# install user applicant
install_shadowsock
install_docker
install_pip
install_aurman
install_go

# --------------------------------------------------clean work------------------------------------------------
popd
