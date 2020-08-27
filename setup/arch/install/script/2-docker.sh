#!/bin/bash

function install(){
    echo "------------------------ 安装 docker -------------------------\n"
    sudo pacman -S --noconfirm -q docker docker-compose

    sudo usermod -aG docker ${USER}
    newgrp docker
    
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

install
