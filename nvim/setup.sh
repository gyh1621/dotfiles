set -e

. ../common.sh

[ -f ~/.vimrc ] && rm ~/.vimrc && echo "Deleted existed ~/.vimrc"
[ -f ~/.vimrc.bundles ] && rm ~/.vimrc.bundles && echo "Deleted existed ~/.vimrc.bundles"
[ -d ~/.vim ] && rm -rf ~/.vim && echo "Deleted existed ~/.vim"
[ -d ~/.config/coc ] && rm -rf ~/.config/coc && echo "Deleted existed ~/.config/coc"
[ -d ~/.config/nvim ] && rm -rf ~/.config/nvim && echo "Deleted existed ~/.config/nvim"
[ -d ~/.local/share/nvim ] && rm -rf ~/.local/share/nvim && echo "Deleted existed ~/.local/share/nvim"


function prepare_for_macos {
    [ -x "$(command -v "nvim")" ] || { echo "Installing nvim"; brew install nvim; }
    [ -x "$(command -v "pbcopy")" ] || { echo "pbcopy not found, exit"; exit 1; }
    # ripgrep
    [ -x "$(command -v "rg")" ] || { echo "Installing ripgrep"; brew install ripgrep; }
    # lazygit
    [ -x "$(command -v "lazygit")" ] || { echo "Installing lazygit"; brew install lazygit; }
    # bottom
    [ -x "$(command -v "btm")" ] || { echo "Installing bottom"; brew install bottom; }
}

function prepare_for_centos {
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    yum install -y neovim python3-neovim
}

if [[ "$OS" == "Darwin"* ]]; then
    prepare_for_macos
else if [[ "$OS" == "Amazon Linux"* ]]; then
    prepare_for_centos
else
    echo "not supported"
fi

git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# link user dir to ~/.config/nvim/user
ln -s ~/dotfiles/nvim/user ~/.config/nvim/lua/user

# init AstroNvim && treesitter
nvim --headless -c 'quitall'

# install lsp servers
nvim --headless \
    -c 'LspInstall pyright' \
    -c 'LspInstall bashls' \
    -c 'LspInstall lus_ls' \
    -c 'LspInstall tsserver' \
    -c 'LspInstall rust_analyzer' \
    -c 'LspInstall gopls' \
    -c 'quitall'
