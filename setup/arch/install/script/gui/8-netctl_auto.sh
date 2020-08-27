#!/bin/bash
# [参考: systemd-timesyncd_arch](https://wiki.archlinux.org/index.php/Systemd-timesyncd_)

function install(){
    echo "------------------------ 自动切换wifi -------------------------\n"
    yay -S --noconfirm -q wpa_actiond
    sudo systemctl start netctl-auto@wlp3s0.service
    sudo systemctl enable netctl-auto@wlp3s0.service
}

install
