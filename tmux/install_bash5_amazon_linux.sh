set -e

. ../common.sh

function install_in_amazon_linux() {
  cd "$(mktemp -d)"
  sudo yum -y groupinstall "Development Tools"
  sudo yum -y install curl

  curl -O http://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz
  tar xvf bash-5.*.tar.gz
  cd bash-5.*/
  ./configure
  make
  sudo make install

  echo "Bash version is now $(bash --version | head -n1 | cut -d" " -f4)"
  echo "Please log out and log back in to use the new bash version"
}

minimum_bash_version="5.0"
# check bash version
bash_version=$(bash --version | grep -oP 'version \K\d+\.\d+')

version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

if version_gt $bash_version $minimum_bash_version; then
  echo "Bash version is $bash_version"
  exit 0
fi

if [[ $OS == "Amazon Linux"* ]]; then
  install_in_amazon_linux
else
  echo "Not supported OS"
  exit 1
fi

# check bash version again
bash_version=$(bash --version | grep -oP 'version \K\d+\.\d+')
if [[ $bash_version < $minimum_bash_version ]]; then
  echo "Bash version check failed: $bash_version"
  exit 1
fi


