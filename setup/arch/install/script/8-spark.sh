#!/bin/bash

function install(){
    echo "------------------------ 安装 spark -------------------------\n"
    wget -c http://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.0.0-preview/spark-3.0.0-preview-bin-hadoop2.7.tgz -O spark.tgz
    tar -xzf spark.tgz && sudo mv spark /usr/local/src && sudo ln -s /usr/local/src/spark/bin/spark-submit /usr/local/bin/spark-submit
    rm spark.tgz
}

install
