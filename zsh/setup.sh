# detect os
# https://unix.stackexchange.com/a/6348
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi
echo $OS:$VER

USERNAME=$USER

# install zsh
function install_zsh_macos {
    ######## never test ######
    sudo brew install zsh zsh-completions git
}

function install_zsh_arch {
    sudo pacman -S --noconfirm zsh
}

function install_zsh_ubuntu {
    sudo apt update && sudo apt install zsh git -y
}

function install_zsh_gentoo {
    sudo emerge -v app-shells/zsh
    sudo emerge -v dev-vcs/git
    sudo emerge -v app-shells/gentoo-zsh-completions
}

function install_zsh_plugins {
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    sudo sed -i "1iauth sufficient   pam_wheel.so trust group=chsh" /etc/pam.d/chsh
    sudo groupadd chsh
    sudo usermod -a -G chsh $USERNAME
    chsh -s /bin/zsh
    #usermod -s /bin/zsh $USERNAME
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt
    ln -s ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    git clone https://github.com/ergenekonyigit/lambda-gitster.git /tmp/tmp-lambda && cp /tmp/tmp-lambda/lambda-gitster.zsh-theme ~/.oh-my-zsh/custom/themes
    git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH/custom/plugins/zsh-vi-mode
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
    fi
    # copy zshrc
    cp $(dirname $(readlink -f ${BASH_SOURCE[0]}))/.zshrc $HOME
    if [[ "$OS" == "Gentoo"* ]]; then
        sed -i '2i\\n# Gentoo completions' $HOME/.zshrc
        sed -i '4i\autoload -U compinit promptinit' $HOME/.zshrc
        sed -i '5i\compinit' $HOME/.zshrc
        sed -i '6i\promptinit; prompt gentoo' $HOME/.zshrc
        sed -i "7izstyle ':completion::complete:*' use-cache 1\n" $HOME/.zshrc
    fi
fi

# iterm2 mark
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
