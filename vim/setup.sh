#!/bin/bash

scriptPath=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
echo -n "scriptPath: "${scriptPath}

rcPath=${scriptPath}/.vimrc
bundlePath=${scriptPath}/.vimrc.bundles

# add config link
ln -s ${rcPath} $HOME/.vimrc
ln -s ${bundlePath} $HOME/.vimrc.bundles

# install dependencies
sudo apt install git build-essential cmake python3-dev

# install plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# compile YCM
cd $HOME/.vim/bundle/YouCompleteMe
python3 install.py

