set -e

. ../common.sh

function install_in_amazon_linux() {

  # source: https://gist.github.com/muralisc/dbb998a8555acc577ce2cf7aae8cd9fa

  # install deps
  sudo yum install -y gcc kernel-devel make ncurses-devel

  # DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
  (
  cd "$(mktemp -d)"
  curl -LOk https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz
  tar -xf libevent-2.1.11-stable.tar.gz
  cd libevent-2.1.11-stable
  ./configure --prefix=/usr/local
  make
  sudo make install
  )

  # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
  (
  cd "$(mktemp -d)"
  curl -LOk https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
  tar -xf tmux-3.3a.tar.gz
  cd tmux-3.3a
  LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
  make
  sudo make install
  )
}

install_tmux=false
if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not installed"
    install_tmux=true
fi
if [[ $(tmux -V | cut -d' ' -f2) < 3.2 ]]; then
    echo "tmux version < 2.1"
    install_tmux=true
fi
if [ "$install_tmux" = true ]; then
    echo "Installing tmux"
    if [[ $OS == "Amazon Linux"* ]]; then
      install_in_amazon_linux
    else
        echo "Not supported OS"
        exit 1
    fi
fi

# check tmux version again
if [[ $(tmux -V | cut -d' ' -f2) < 3.2 ]]; then
    echo "tmux version < 3.2"
    exit 1
fi

