#!/bin/bash

function install(){
    echo "------------------------ node安装 -------------------------\n"
    # node-gym 需要python2
    sudo pacman -S --noconfirm -q npm python2
    npm config set registry https://registry.npm.taobao.org
    yay -S --nodiffmenu --nocleanmenu nvm
    # 还需要 source init_nvm.sh
    # echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
}

install
