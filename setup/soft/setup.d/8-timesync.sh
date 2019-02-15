#!/bin/bash

function install(){
    echo "------------------------ 时间同步 -------------------------\n"
    sudo timedatectl set-ntp true
    sudo tee /etc/systemd/timesyncd.conf <<-EOF
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
EOF
}

install()
