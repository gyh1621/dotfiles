set -e

. ../common.sh

# read env MODE, if empty set to "install"
mode=${MODE:-install}

if [ $mode == "copy" ]; then
	[ -d ~/.config/nvim ] && rm -rf ~/.config/nvim && echo "Deleted existed ~/.config/nvim"
    ln -s ~/dotfiles/nvim/astro ~/.config/nvim
    echo "AstroNvim config updated"
    exit 0
fi

# delete backup
[ -d ~/.config/nvim.bak ] && rm -rf ~/.config/nvim.bak
[ -d ~/.local/share/nvim.bak ] && rm -rf ~/.local/share/nvim.bak
[ -d ~/.local/state/nvim.bak ] && rm -rf ~/.local/state/nvim.bak
[ -d ~/.cache/nvim.bak ] && rm -rf ~/.cache/nvim.bak

# backup if exist
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.bak
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim ~/.local/state/nvim.bak
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim ~/.cache/nvim.bak

[ -f ~/.vimrc ] && rm ~/.vimrc && echo "Deleted existed ~/.vimrc"
[ -f ~/.vimrc.bundles ] && rm ~/.vimrc.bundles && echo "Deleted existed ~/.vimrc.bundles"
[ -d ~/.vim ] && rm -rf ~/.vim && echo "Deleted existed ~/.vim"
[ -d ~/.config/coc ] && rm -rf ~/.config/coc && echo "Deleted existed ~/.config/coc"
[ -d ~/.config/nvim ] && rm -rf ~/.config/nvim && echo "Deleted existed ~/.config/nvim"
[ -d ~/.local/share/nvim ] && rm -rf ~/.local/share/nvim && echo "Deleted existed ~/.local/share/nvim"

function prepare_for_macos {
	[ -x "$(command -v "nvim")" ] || {
		echo "Installing nvim"
		brew install nvim
	}
	[ -x "$(command -v "pbcopy")" ] || {
		echo "pbcopy not found, exit"
		exit 1
	}
	# ripgrep
	[ -x "$(command -v "rg")" ] || {
		echo "Installing ripgrep"
		brew install ripgrep
	}
	# bottom
	[ -x "$(command -v "btm")" ] || {
		echo "Installing bottom"
		brew install bottom
	}
}

function prepare_for_amazon_linux {
	if [ -x "$(command -v "nvim")" ]; then
		echo "nvim is already installed."
	else
		echo "Installing nvim..."
		./install_nvim_amazon_linux.sh
	fi

	# Install Node.js if not installed
	if [ -x "$(command -v "node")" ]; then
		echo "Node.js is already installed."
	else
		echo "Installing Node.js..."
		./install_nodejs_amazon_linux.sh
	fi

	# ripgrep
	[ -x "$(command -v "rg")" ] || {
		echo "Installing ripgrep"
		sudo yum install -y yum-utils
		sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
		sudo yum install -y ripgrep
	}
	echo "bottom might not be available in standard repos for Amazon Linux"
}

if [[ "$OS" == "Darwin"* ]]; then
	prepare_for_macos
elif [[ "$OS" == "Amazon Linux"* ]]; then
	prepare_for_amazon_linux
else
	echo "OS not supported"
fi

# link astro dir to ~/.config/nvim
ln -s ~/dotfiles/nvim/astro ~/.config/nvim

# init AstroNvim && treesitter
nvim --headless +q
nvim --headless -c 'TSInstallSync' +q

# # install lsp servers
# nvim --headless \
#     -c 'LspInstall pyright' \
#     -c 'LspInstall bashls' \
#     -c 'LspInstall lus_ls' \
#     -c 'LspInstall tsserver' \
#     -c 'LspInstall rust_analyzer' \
#     -c 'LspInstall gopls' \
#     -c 'quitall'
