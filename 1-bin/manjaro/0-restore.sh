#!/bin/bash
set -e

cd backup

echo "------------------------ install pkglist -------------------------\n"
sudo pacman -S --noconfirm -q --needed - < pkglist.txt


echo "------------------------ install pkglist_aur -------------------------\n"
yay -S --noconfirm -q --needed - < pkglist_aur.txt


echo "------------------------ install oh my zsh -------------------------\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


git config --global user.name "wzs"
git config --global user.email "zhensheng.five@gmail.com"
git config --global url."git@github.com:".insteadOf "https://github.com/"

# 这一部分后根据需要解除注释

# echo "------------------------ copy etc -------------------------\n"
# sudo cp etc/environment /etc/environment
# sudo cp etc/systemd/system/sslocal.service /etc/systemd/system/sslocal.service
# sudo cp etc/systemd/logind.conf /etc/systemd/logind.conf
# sudo cp etc/hosts /etc/hosts

# echo "------------------------ copy home/wzs -------------------------\n"
# rm -rf ~/.config
# cp -r wzs/.config ~
# cp -r wzs/.local/bin ~/.local
# cp -r wzs/picture ~
# cp -r wzs/code ~
# cp wzs/.zshrc ~

# echo "------------------------ all done -------------------------\n"
