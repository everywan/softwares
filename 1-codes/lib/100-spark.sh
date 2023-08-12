#!/bin/bash

function install(){
    echo "------------------------ 安装 spark -------------------------\n"
    wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2-scala2.13.tgz -O spark.tgz
    tar -xzf spark.tgz && sudo mv spark /usr/local/src && sudo ln -s /usr/local/src/spark/bin/spark-submit /usr/local/bin/spark-submit
    rm spark.tgz
}

# 建议使用 docker 替代
install
