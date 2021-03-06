#!/bin/bash
#
# Installation script based on https://docs.docker.com/engine/installation/linux/docker-ce/debian/
# For Debian Stretch x64

## Custom echo
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'

## Color-echo.
#  Reset text attributes to normal + without clearing screen.
Reset="tput sgr0"
# arg $1 = message
# arg $2 = Color
cecho() {
  echo -e "${2}"
  echo "${1}"
  $Reset # Reset to normal.
  return
}

# Display header
header() {
  cecho "------------------------------------------------------------------------------" $yellow
  cecho "$*" $yellow
  cecho "------------------------------------------------------------------------------" $yellow

}

# Who are you?
if [ "$(id -u)" != "0" ]; then
  cecho "Genesis is for ROOT" $red
  cecho "❯ su" $red
  exit 1
fi

VERSION_DOCKER_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

header "Prerequisites by updating apt and installing docker repository"
apt-get remove docker docker-engine docker.io
apt-get update
apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
cecho "apt and docker repository done" $green


header "Install Docker CE"
apt-get update
apt-get install --yes --force-yes docker-ce
cecho "Hello World" $yellow
docker run hello-world
header "Install Docker compose"
curl -L https://github.com/docker/compose/releases/download/$VERSION_DOCKER_COMPOSE/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
cecho "Docker done" $green
