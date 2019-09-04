#!/bin/bash

function install(){
  echo "------------------------ frps -------------------------\n"
  git clone https://github.com/fatedier/frp.git
  pushd frp
  make frpc
  popd
  sudo mkdir /etc/frp/
  sudo tee /etc/frp/frpc.ini <<-'EOF'
[common]
server_addr = remote_ip
server_port = 6000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 2000
EOF

  sudo tee /etc/systemd/system/frpc.service <<-'EOF'
[Unit]
Description=frp client service
After=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=60
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl start frpc.service
  sudo systemctl enable frpc.service
}

install
