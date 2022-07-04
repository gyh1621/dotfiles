set -e

. ../common.sh

[ -f ~/.vimrc ] && rm ~/.vimrc && echo "Deleted existed ~/.vimrc"
[ -f ~/.vimrc.bundles ] && rm ~/.vimrc.bundles && echo "Deleted existed ~/.vimrc.bundles"
[ -d ~/.vim ] && rm -rf ~/.vim && echo "Deleted existed ~/.vim"
[ -d ~/.config/coc ] && rm -rf ~/.config/coc && echo "Deleted existed ~/.config/coc"
#[ -d ~/.vim/coc-settings.json ]

# link config files
mkdir -p $HOME/.vim
if [[ "$OS" == "Darwin"* ]]; then
    ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/.vimrc $HOME/.vimrc
    ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/.vimrc.bundles $HOME/.vimrc.bundles
    ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/coc-settings.json $HOME/.vim/coc-settings.json
else
    ln -s $(dirname $(readlink -f ${BASH_SOURCE[0]}))/.vimrc $HOME/.vimrc
    ln -s $(dirname $(readlink -f ${BASH_SOURCE[0]}))/.vimrc.bundles $HOME/.vimrc.bundles
    ln -s $(dirname $(readlink -f ${BASH_SOURCE[0]}))/coc-settings.json $HOME/.vim/coc-settings.json
fi


function prepare_for_macos {
    brew install node
    brew install vim
    # for vim
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    sudo ln -s /opt/homebrew/Cellar/vim/*/bin/vim /usr/local/bin/vim
}

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
    install_common
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
vim +PlugInstall +qall

# install coc plugins
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
    echo '{"dependencies": {}}' > package.json
fi
npm install coc-json coc-rust-analyzer coc-pyright coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

echo -e "\n=====RUST SUPPORT===="
echo "1. download rust-analyzer"
echo "2. compile https://github.com/pr2502/ra-multiplex and put ra-multiplex* to ~/.local/bin"
