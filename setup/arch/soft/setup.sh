#!/bin/bash
set -x
set -e

function main(){
}

if [ ! -d "/tmp/install" ]; then
    mkdir -p /tmp/install
fi

pushd /tmp/install
main
popd
