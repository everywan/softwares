#!/bin/bash

function install(){
  echo "------------------------ frps -------------------------\n"
  git clone https://github.com/fatedier/frp.git
  pushd frp
  make frpc
  sudo mv bin/frpc /usr/local/bin/frpc
  make frps
  sudo mv bin/frps /usr/local/bin/frps
  popd
  sudo mkdir /etc/frp/
}

install
