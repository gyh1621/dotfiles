set -e

. common.sh


function install_bat {
    if [[ "$OS" == "Arch Linux" ]]; then
        echo ""
    elif [[ "$OS" == "Darwin"* ]]; then
        brew install bat
    elif [[ "$OS" == "Ubuntu"* ]]; then
        install_bat_8664
    elif [[ "$OS" == "Raspbian"* ]]; then
        echo ""
    elif [[ "$OS" == "Gentoo"* ]]; then
        echo ""
    elif [[ "$OS" == "Amazon Linux"* ]]; then
        install_bat_8664
    fi
}

function install_bat_8664 {
    sudo rm -rf /tmp/bat*
    wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat-v0.21.0-x86_64-unknown-linux-musl.tar.gz -P /tmp
    tar -xzf /tmp/bat-v0.21.0-x86_64-unknown-linux-musl.tar.gz -C /tmp
    sudo mv /tmp/bat-v0.21.0-x86_64-unknown-linux-musl/bat /usr/local/bin
}

function install_thefuck {
    if [[ "$OS" == "Darwin"* ]]; then
        brew install thefuck
    elif [[ "$OS" == "Ubuntu"* ]]; then
        ""
    elif [[ "$OS" == "Raspbian"* ]]; then
        echo ""
    elif [[ "$OS" == "Gentoo"* ]]; then
        echo ""
    elif [[ "$OS" == "Amazon Linux"* ]]; then
        pip install thefuck
    fi
}


install_bat
install_thefuck
