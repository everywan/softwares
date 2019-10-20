#!/bin/bash
# set -x
set -e

# curl -o- -L https://raw.githubusercontent.com/everywan/soft/master/setup/arch/soft/setup.sh | bash

path="."

need_cmd () {
  if ! hash "$1" &>/dev/null; then
    echo "need $1"
    exit 1
  fi
}

fetch_repo () {
    if [[ -d "/tmp/install/soft" ]]; then
        pushd "/tmp/install/soft"
        echo "已经下载 soft 仓库, 拉取更新"
        git pull
        popd
    else
      git clone https://github.com/everywan/soft
      if [ $? -ne 0 ]; then
        echo "git soft 仓库失败"
        exit 0
      fi
    fi
}

function setupPath(){
  need_cmd git
  fetch_repo
  path=/tmp/install/soft/setup/arch/soft/setup.d/
}

function exec(){
  /bin/bash $path/$1
}

function main(){
  setupPath
  echo "开始安装, 路径为 $path"
  for file in `ls $path`
  do
    exec $file
  done
  echo "安装完成"
}

if [ ! -d "/tmp/install" ]; then
    mkdir -p /tmp/install
fi

pushd /tmp/install
main $@
popd
