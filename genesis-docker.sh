#!/bin/bash
#
# Installation script based on https://docs.docker.com/engine/installation/linux/debian/#/debian-jessie-80-64-bit
# For Debian Jessie x64
# And for docker compose https://docs.docker.com/compose/install/

## Custom echo
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'

## Color-echo.
#  Reset text attributes to normal + without clearing screen.
alias Reset="tput sgr0"
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
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

VERSION_DOCKER_COMPOSE="1.8.0"

header "Prerequisites by updating apt repository"
apt-get update
apt-get purge "lxc-docker*"
apt-get purge "docker.io*"
apt-get update
apt-get install -y -q apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
rm -f /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-engine
apt-get update
cecho "apt repository done" $green

header "Install Docker"
apt-get install -y -q docker-engine
service docker start
cecho "Hello World" $yellow
docker run hello-world
cecho "Docker done" $green

header "Install Docker Compose"
curl -L https://github.com/docker/compose/releases/download/$VERSION_DOCKER_COMPOSE/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
cecho "Docker compose done" $green
