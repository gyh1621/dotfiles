# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

scriptPath=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
echo -n "scriptPath: "${scriptPath}

# make link
ln -s ${scriptPath}/.tmux.conf $HOME/.tmux.conf

# install plugins
# source tmux
tmux source $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/bin/install_plugins

# source powerline
powerlinePath=$(dirname $(python -c "import powerline; print(powerline.__file__)"))
powerline=${powerlinePath}"/bindings/tmux/powerline.conf"
echo ${powerline}
sed -i "s!# SOURCE POWERLINE #!source ${powerline}!g" $HOME/.tmux.conf
echo "done"

# source tmux
tmux source-file $HOME/.tmux.conf
