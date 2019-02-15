#!/bin/bash

function install(){
    echo "------------------------ 安装 docker  -------------------------\n"
    # curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    sudo pacman -S --noconfirm docker

    echo "配置docker免sudo. 注意: 需要重新登入终端, user 才可以使用docekr组的权限"
    sudo usermod -aG docker ${USER}
    
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

install()
