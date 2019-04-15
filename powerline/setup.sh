#!/bin/bash

pip install --user powerline-status

# install fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# install tmux powerline segment
pip install --user powerline-mem-segment

scriptPath=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
echo -n "scriptPath: "${scriptPath}

if [ ! -d "$HOME/.config" ]; then
    mkdir $HOME/.config
fi

ln -s ${scriptPath} $HOME/.config/powerline
