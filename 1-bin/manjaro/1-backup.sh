#!/bin/bash
set -e

DIRNAME="/tmp/manjaro_$(date +%Y%m%d)"
if [ ! -d "$DIRNAME" ]; then
    mkdir $DIRNAME
fi

set +e

echo "------------------------ backup pkglist -------------------------\n"
pacman -Qqen > /$DIRNAME/pkglist.txt
pacman -Qqem > /$DIRNAME/pkglist_aur.txt
echo "------------------------ backup pkglist done. -------------------------\n"
echo "------------------------ 如果是迁移到其他机器，需要移除 pkglist 里的硬件相关软件. -------------------------\n"

echo "------------------------ 开始备份，请不要操作其他软件 -------------------------\n"

echo "------------------------ backup home -------------------------\n"
if [ -d "~.cache" ]; then
    mv ~/.cache /$DIRNAME
fi
zip -r /$DIRNAME/wzs.zip /home/wzs
if [ -d "/$DIRNAME/.cache" ]; then
    mv /$DIRNAME/.cache ~
fi

echo "------------------------ backup etc -------------------------\n"
zip -r /$DIRNAME/etc.zip /etc

echo "------------------------ backup done -------------------------\n"

zip -r /tmp/manjaro_$(date +%Y%m%d).zip /$DIRNAME

