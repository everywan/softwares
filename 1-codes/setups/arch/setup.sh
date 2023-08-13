# 工作站
#!/bin/bash
# set -x
set -e

# 参考 https://spacevim.org/cn/install.sh 编写, 目前脚本还不完善.

# curl -o- -L https://raw.githubusercontent.com/everywan/softwares/master/setup/arch/soft/setup.sh | bash

path="."
install_path="/tmp/install/softwares"

need_cmd () {
  if ! hash "$1" &>/dev/null; then
    echo "need install $1"
    exit 1
  fi
}

fetch_repo () {
    if [[ -d $install_path ]]; then
        pushd $install_path
        echo "已经下载 soft 仓库, 拉取更新"
        git pull
        popd
    else
      git clone https://github.com/everywan/softwares
      if [ $? -ne 0 ]; then
        echo "git soft 仓库失败"
        exit 0
      fi
    fi
}

function setupPath(){
  need_cmd git
  fetch_repo
  path=$install_path+"/1-codes/setups/arch"
}

function exec(){
  /bin/bash $path/$1
}

function main(){
  setupPath
  echo "开始安装, 路径为 $path"
  for file in `ls $path`
  do
    exec $file
  done
  echo "安装完成"
}

if [ ! -d "/tmp/install" ]; then
    mkdir -p /tmp/install
fi

pushd /tmp/install
main $@
popd
