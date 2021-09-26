set -e

[ -d ~/.tmux ] && rm -rf ~/.tmux && echo "Deleted existed ~/.tmux"
[ -f ~/.tmux.conf ] && rm ~/.tmux.conf && echo "Deleted existed ~/.tmux.conf"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

scriptPath=$(dirname $(greadlink -f ${BASH_SOURCE[0]}))
echo "scriptPath: "${scriptPath}

# extrakto
[ -d ~/.config/extrakto ] && rm -rf ~/.config/extrakto
mkdir -p ~/.config/extrakto
ln -s ~/dotfiles/tmux/extrakto.conf ~/.config/extrakto/extrakto.conf

# make link
ln -s ${scriptPath}/.tmux.conf $HOME/.tmux.conf

# source tmux if currently inside a tmux session
[ -z "${TMUX}" ] || tmux source $HOME/.tmux.conf

echo "Hit prefix+I inside a tmux session to install plugins"
