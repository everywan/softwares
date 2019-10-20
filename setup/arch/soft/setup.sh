#!/bin/bash
# set -x
# set -e

# curl -o- -L https://github.com/everywan/soft/setup/arch/soft/setup.sh | bash

path="."

function setupPath(){
  sudo pacman -Sy git
  git clone https://github.com/everywan/soft
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
main
popd
