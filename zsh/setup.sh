set -e

. ../common.sh

[ -f ~/.zshrc ] && rm ~/.zshrc && echo "Deleted existed ~/.zshrc"
[ -d ~/.oh-my-zsh ] && rm -rf ~/.oh-my-zsh && echo "Deleted existed ~/.oh-my-zsh"
[ -d ~/.zsh ] && rm -rf ~/.zsh && echo "Deleted existed ~/.zsh"

# install zsh
function install_zsh_macos {
    brew install coreutils  # for greadlink
    brew install zsh zsh-completions git
    brew install thefuck
    brew install difftastic
    git config --global diff.external difft
}

function install_zsh_arch {
    sudo pacman -S --noconfirm zsh
}

function install_zsh_ubuntu {
    sudo apt update && sudo apt install zsh git curl -y
    # install go for fzf
    #cd /tmp && curl -OL https://golang.org/dl/go1.18.4.linux-amd64.tar.gz && cd -
    #sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.18.4.linux-amd64.tar.gz
    #export PATH=$PATH:/usr/local/go/bin
}

function install_zsh_debian {
    sudo apt install zsh zplug -y
}

function install_zsh_gentoo {
    sudo emerge -v app-shells/zsh
    sudo emerge -v dev-vcs/git
    sudo emerge -v app-shells/gentoo-zsh-completions
}

function install_zsh_plugins {

    if [[ "$OS" != "Darwin"* ]]; then
        # sudo sed -i "1iauth sufficient   pam_wheel.so trust group=chsh" /etc/pam.d/chsh
        # sudo groupadd chsh
        # sudo usermod -a -G chsh $USERNAME
        chsh -s /bin/zsh
        #usermod -s /bin/zsh $USERNAME
    fi

    [ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc

    git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/plugins/fzf-tab

    git clone --depth 1 https://github.com/sindresorhus/pure.git ~/.zsh/pure

    git clone --depth 1 https://github.com/agkozak/zsh-z.git ~/.zsh/plugins/zsh-z

    git clone --depth 1 https://github.com/romkatv/zsh-defer.git ~/.zsh/plugins/zsh-defer

    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions

    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting

    git clone --depth 1 https://github.com/jeffreytse/zsh-vi-mode.git ~/.zsh/plugins/zsh-vi-mode

    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh >> ~/.zsh/plugins/fancy-ctrl-z.plugin.zsh

    git clone --depth 1 https://github.com/bigH/git-fuzzy.git ~/.zsh/plugins/git-fuzzy

}


if [ ! -e "$HOME/.zshrc" ]; then
    if [[ "$OS" == "Arch Linux" ]]; then
        install_zsh_arch
        install_zsh_plugins
    elif [[ "$OS" == "Darwin"* ]]; then
        install_zsh_macos
        install_zsh_plugins
    elif [[ "$OS" == "Ubuntu"* ]]; then
        install_zsh_ubuntu
        install_zsh_plugins
    elif [[ "$OS" == "Raspbian"* ]]; then
        install_zsh_ubuntu
        install_zsh_plugins
    elif [[ "$OS" == "Gentoo"* ]]; then
        install_zsh_gentoo
        install_zsh_plugins
    elif [[ "$OS" == "Amazon Linux"* ]]; then
        sudo yum install util-linux-user
        install_zsh_plugins
    elif [[ "$OS" == "Debian"* ]]; then
        install_zsh_debian
        install_zsh_plugins
    else
        echo "$OS is not supported"
        exit
    fi
    # link zshrc
    [ -f ~/.zshrc ] && rm ~/.zshrc
    if [[ "$OS" == "Darwin"* ]]; then
        ln -s $(dirname $(greadlink -f ${BASH_SOURCE[0]}))/.zshrc $HOME/.zshrc
    else
        ln -s $(pwd)/.zshrc $HOME/.zshrc
    fi
    if [[ "$OS" == "Gentoo"* ]]; then
        sed -i '2i\\n# Gentoo completions' $HOME/.zshrc
        sed -i '4i\autoload -U compinit promptinit' $HOME/.zshrc
        sed -i '5i\compinit' $HOME/.zshrc
        sed -i '6i\promptinit; prompt gentoo' $HOME/.zshrc
        sed -i "7izstyle ':completion::complete:*' use-cache 1\n" $HOME/.zshrc
    fi

    # setup git
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
fi

exec zsh

# iterm2 mark
# curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
# uninstall shell integration
# https://gist.github.com/victor-torres/67c272be0cb0d6989729
