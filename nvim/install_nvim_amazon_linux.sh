set -e

sudo yum groups install -y Development\ tools

function install_cmake_if_needed {
    # Check if CMake is installed and get its version
    cmake_version=$(cmake --version 2>/dev/null | grep "cmake version" | awk '{print $3}')
    
    # Check if version is greater than or equal to 3.10
    if [[ -n "$cmake_version" && "$(printf '%s\n' "3.10" "$cmake_version" | sort -V | head -n1)" == "3.10" ]]; then
        echo "CMake version $cmake_version is already installed and up-to-date."
    else
        echo "Installing CMake 3.10.0..."
	# remove outdated cmake and build 3.10 from source
	sudo yum remove -y cmake
	sudo yum install -y gcc-c++
	(
	cd "$(mktemp -d)"
	wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
	tar -xvzf cmake-3.10.0.tar.gz
	cd cmake-3.10.0
	./bootstrap --system-curl
	make
	sudo make install
	)
    fi
}

install_cmake_if_needed

sudo pip3 install neovim --upgrade

(
cd "$(mktemp -d)"
git clone --depth 1 https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
)
