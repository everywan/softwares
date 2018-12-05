#!/bin/bash

readonly BACKUP_FOLDER="$HOME/Documents/backup"
readonly BACKUP="backup"
readonly RESTORE="restore"

function main(){
    if [ $1 = $RESTORE ];then
        restore
    else
        backup
    fi
}

function restore(){
    # vscode 快捷键恢复
    ln /Applications/code.app/Contents/Resources/app/bin/code /usr/local/bin/code

    # git config --global user.name "wuzhensheng"
    # git config --global user.email "zhensheng.five@gmail.com"

    if [ -f $HOME/.zshrc ];then
        rm $HOME/.zshrc
    fi
    ln ${BACKUP_FOLDER}/zshrc $HOME/.zshrc

    # 恢复 ssh 公钥私钥
    mkdir -p ~/.ssh
    ln ${BACKUP_FOLDER}/ssh/ $HOME/.ssh/id_rsa
    ln ${BACKUP_FOLDER}/ssh/ $HOME/.ssh/id_rsa.pub

    # 恢复 shadowsocks 配置
    sudo mkdir -p /etc/shadowsocks
    sudo chown $USER /etc/shadowsocks
    ln ${BACKUP_FOLDER}/shadowsocks/ /etc/shadowsocks/shadowsocks.json

    # 恢复iterm2配置
    cp ./iterm2.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/

    exec zsh
}

function backup(){
    ln $HOME/.zshrc ${BACKUP_FOLDER}/zshrc

    # ssh
    mkdir -p ${BACKUP_FOLDER}/ssh
    ln $HOME/.ssh/id_rsa ${BACKUP_FOLDER}/ssh/
    ln $HOME/.ssh/id_rsa.pub ${BACKUP_FOLDER}/ssh/

    # shadowsocks
    mkdir -p ${BACKUP_FOLDER}/shadowsocks
    ln /etc/shadowsocks/shadowsocks.json ${BACKUP_FOLDER}/shadowsocks/
}

if [ $(basename "$0") == "backup-restore.sh" ]; then
    if [ ! -d $BACKUP_FOLDER ]; then
        mkdir -p $BACKUP_FOLDER
    fi
    pushd $BACKUP_FOLDER
    main
    popd
fi