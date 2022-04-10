#!/bin/bash

function install(){
    echo "------------------------ jupyter安装 -------------------------\n"
    sudo pip install jupyterlab
    # 启动
    # jupyter lab
    sudo jupyter labextension install @jupyterlab/github
    sudo jupyter labextension install @jupyterlab/toc
    sudo jupyter labextension install @jupyterlab-drawio
}

# 建议使用 docker 替代
# install
