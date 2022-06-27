set -e

. ../common.sh

[ -f ~/.vimrc ] && rm ~/.vimrc && echo "Deleted existed ~/.vimrc"
[ -f ~/.vimrc.bundles ] && rm ~/.vimrc.bundles && echo "Deleted existed ~/.vimrc.bundles"
[ -d ~/.vim ] && rm -rf ~/.vim && echo "Deleted existed ~/.vim"

# link config files
[ -f ~/.zshrc ] && rm ~/.zshrc
if [[ "$OS" == "Darwin"* ]]; then
    ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/.vimrc $HOME/.vimrc
    ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/.vimrc.bundles $HOME/.vimrc.bundles
else
    ln -s $(dirname $(readlink -f ${BASH_SOURCE[0]}))/.vimrc $HOME/.vimrc
    ln -s $(dirname $(readlink -f ${BASH_SOURCE[0]}))/.vimrc.bundles $HOME/.vimrc.bundles
fi


function prepare_for_ubuntu {
    sudo apt install -y git build-essential cmake python3-dev
}

function install_common {
    # vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

if [[ "$OS" == "Arch Linux" ]]; then
    echo "not supported"
elif [[ "$OS" == "Darwin"* ]]; then
    echo "not supported"
elif [[ "$OS" == "Ubuntu"* ]]; then
    prepare_for_ubuntu
    install_common
elif [[ "$OS" == "Raspbian"* ]]; then
    echo "not supported"
elif [[ "$OS" == "Gentoo"* ]]; then
    echo "not supported"
elif [[ "$OS" == "Amazon Linux"* ]]; then
    install_common
fi

# install plugins
vim -E -s -u $HOME/.vimrc.bundles +PlugInstall +qall
