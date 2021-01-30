#!/bin/bash

function install(){
  echo "------------------------ frpc -------------------------\n"
  sudo tee /etc/frp/frpc.ini <<-'EOF'
[common]
server_addr = xxx
bind_port = 6000
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
