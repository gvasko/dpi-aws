#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

# source: https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository

apt-get update

apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce

usermod -a -G docker ubuntu

DOCKER_OPTS='-H tcp://0.0.0.0:4243'
cat /lib/systemd/system/docker.service | sed "s:^\(ExecStart\)\(.\+\)$:\1\2 $DOCKER_OPTS":

service docker restart

echo "Log out and log back in again to pick up the new docker group permissions."
