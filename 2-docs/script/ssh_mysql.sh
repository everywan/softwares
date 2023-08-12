#!/bin/bash

# 设置端口转发
ssh -fNg -L 3306:localhost:3306 -p 22 everywan@xiagaoxiawan.com

if [ "$1" == "test" ];then
    mycli -h 127.0.0.1 -u test -pxxxx --database test
elif [ "$1" == "root" ];then
    mycli -h 127.0.0.1 -u root -proot --database root
else
    mycli -h 127.0.0.1 -u root -proot --database root
fi

# 结束端口转发
kill `ps -ef|grep 3306:localhost:3306 |grep -v 'grep' |awk '{print $2}'`

# add to ~/.bashrc
# alias ssh_mysql="~/.config/script/ssh_mysql.sh $1"