#!/bin/bash

function install(){
  echo "------------------------ frps -------------------------\n"
  sudo tee /etc/frp/frps.ini <<-'EOF'
[common]
bind_port = 6000
EOF

  sudo tee /etc/systemd/system/frps.service <<-'EOF'
[Unit]
Description=frp server service
After=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=60
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl start frps.service
  sudo systemctl enable frps.service
}

install
