#!/bin/bash

function install(){
    echo "------------------------ 可选安装 -------------------------\n"
    curl -sLf https://spacevim.org/cn/install.sh | bash
}

install
