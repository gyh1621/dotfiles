git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

scriptPath=$(dirname $(greadlink -f ${BASH_SOURCE[0]}))
echo -n "scriptPath: "${scriptPath}

# extrakto
mkdir -p ~/.config/extrakto
ln -s ~/dotfiles/tmux/extrakto.conf ~/.config/extrakto/extrakto.conf

# make link
ln -s ${scriptPath}/.tmux.conf $HOME/.tmux.conf

# source tmux
tmux source $HOME/.tmux.conf

echo "start a tmux session and hit prefix+I to install plugins"
