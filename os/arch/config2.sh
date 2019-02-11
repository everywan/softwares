echo "------------------------ i3安装 -------------------------\n"
sudo pacman -S --noconfirm xorg xorg-xinit termite feh rofi scrot imagemagic compton
yay -S i3 polybar

echo "------------------------ 时间同步 -------------------------\n"
sudo timedatectl set-ntp true
sudo tee /etc/systemd/timesyncd.conf <<-EOF
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
EOF

echo "------------------------ 字体安装 -------------------------\n"
sudo pacman -S --noconfirm wqy-microhei ttf-inconsolata ttf-font-awesome
yay -S ttf-mac-fonts ttf-ms-win10
fc-cache -vf

echo "------------------------ 自动切换wifi -------------------------\n"
sudo pacman -S --noconfirm wpa_actiond && sudo systemctl start netctl-auto@wlp3s0.service && sudo systemctl enable netctl-auto@wlp3s0.service

# echo "------------------------ 复制云端备份 -------------------------\n"
# ln -s ~/cloud/backup/config/xinitrc .xinitrc
# ln -s ~/cloud/backup/config/xprofile .xprofile
# ln -s ~/cloud/backup/config/zshrc .zshrc
# ln -s ~/cloud/config/i3 .
# ln -s ~/cloud/config/polybar .
# ln -s ~/cloud/config/termite .
# ln -s ~/cloud/config/rofi .
# sudo cp ~/cloud/backup/config/shadowsocks /etc

# echo "------------------------ 休眠支持需手动配置 -------------------------\n"

echo "------------------------ 声卡配置 -------------------------\n"
sudo pacman -S --noconfirm alsa-utils
sudo gpasswd -a wzs audio

echo "------------------------ 蓝牙配置 -------------------------\n"
sudo pacman -S --noconfirm blueman

# yay -S i3icons2-git