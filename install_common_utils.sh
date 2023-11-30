set -e

. common.sh

function install_btop {
    if [[ "$OS" == "Arch Linux" ]]; then
        echo ""
    elif [[ "$OS" == "Darwin"* ]]; then
        brew install btop
    elif [[ "$OS" == "Ubuntu"* ]]; then
        install_btop_8664
    elif [[ "$OS" == "Raspbian"* ]]; then
        echo ""
    elif [[ "$OS" == "Gentoo"* ]]; then
        echo ""
    elif [[ "$OS" == "Amazon Linux"* ]]; then
        install_btop_8664
    fi
}

function install_btop_8664 {
    sudo rm -rf /tmp/btop*
    wget https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz -P /tmp
    tar -xvjf /tmp/btop-x86_64-linux-musl.tbz -C /tmp
    sudo mv /tmp/btop/bin/btop /usr/local/bin
}


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

function install_lazygit {
    if [[ "$OS" == "Arch Linux" ]]; then
        echo ""
    elif [[ "$OS" == "Darwin"* ]]; then
        brew install lazygit
    elif [[ "$OS" == "Ubuntu"* ]]; then
        install_lazygit_8664
    elif [[ "$OS" == "Raspbian"* ]]; then
        echo ""
    elif [[ "$OS" == "Gentoo"* ]]; then
        echo ""
    elif [[ "$OS" == "Amazon Linux"* ]]; then
        install_lazygit_8664
    fi
}

function install_lazygit_8664 {
    sudo rm -rf /tmp/lazygit*
    wget https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz -P /tmp
    tar -xzf /tmp/lazygit_0.40.2_Linux_x86_64.tar.gz -C /tmp
    sudo mv /tmp/lazygit /usr/local/bin
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
        pip3 install thefuck
    fi
}

function install_chsh {
    # Check if chsh is available
    if command -v chsh >/dev/null 2>&1; then
        echo "chsh is already installed."
    else
        # Based on the $OS value, install chsh
        if [[ "$OS" == "Darwin"* ]]; then
            # MacOS
            echo "chsh is a part of macOS, should be already installed."
        elif [[ "$OS" == "Ubuntu"* ]]; then
            # Ubuntu
            sudo apt-get update
            sudo apt-get install -y util-linux-user
        elif [[ "$OS" == "Raspbian"* ]]; then
            # Raspbian
            sudo apt-get update
            sudo apt-get install -y util-linux-user
        elif [[ "$OS" == "Gentoo"* ]]; then
            # Gentoo
            sudo emerge shadow
        elif [[ "$OS" == "Amazon Linux"* ]]; then
            # Amazon Linux
            sudo yum install -y util-linux-user
        else
            echo "Unsupported operating system: $OS"
        fi
    fi
}



install_bat
install_thefuck
install_chsh
install_lazygit
install_btop
