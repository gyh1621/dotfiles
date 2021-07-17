scriptPath=$(dirname $(greadlink -f ${BASH_SOURCE[0]}))
echo -n "scriptPath: "${scriptPath}

# make link
ln -s ${scriptPath}/.tmux.conf $HOME/.tmux.conf

# source tmux
tmux source $HOME/.tmux.conf
