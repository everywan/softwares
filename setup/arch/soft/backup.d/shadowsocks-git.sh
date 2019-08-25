#!/bin/bash

function install(){
  # 参考 /doc/shadowsocks.md
  echo "------------------------ shadowsocks安装(from git base centos) -------------------------\n"
  sudo yum install git
  mkdir ~/git
  pushd git
  git clone https://github.com/shadowsocks/shadowsocks.git
  cd shadowsocks
  git checkout origin/master -b master
  sudo python setup.py install
  
  # 创建配置文件
  sudo mkdir /etc/shadowsocks/
  tee ./shadowsocks.json <<-'EOF'
{
   "server":"0.0.0.0",
   "server_port":50000,
   "password":"***",
   "timeout":300,
   "method":"aes-256-cfb",
   "fast_open":false,
   "workers": 1
}
EOF
  sudo mv shadowsocks.json /etc/shadowsocks/
  sudo chown root /etc/shadowsocks/shadowsocks.json

  # 启动命令如下
  # ssserver -c /etc/shadowsocks/shadowsocks.json -d start
  popd
}

install
