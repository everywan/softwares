#!/bin/bash
set -e

git config --global user.name "wzs"
git config --global user.email "zhensheng.five@gmail.com"
git config --global url."git@github.com:".insteadOf "https://github.com/"

echo "------------------------ install homebrew -------------------------\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 切换源
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
brew update

echo "------------------------ install brewfile -------------------------\n"
brew bundle install --file=./brewfile

echo "------------------------ install oh-my-zsh -------------------------\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
