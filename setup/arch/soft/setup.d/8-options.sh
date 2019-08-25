#!/bin/bash

function install(){
    echo "------------------------ 可选安装 -------------------------\n"
    yay -S mycli

    curl -sLf https://spacevim.org/cn/install.sh | bash
    
    yay -S deepin-screenshot
}

install
