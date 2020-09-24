#!/bin/bash

function run(){
    echo "------------------------ 执行更新 -------------------------\n"
    pacman -Syu --noconfirm -q
}

run
