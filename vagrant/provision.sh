#!/bin/bash

echo "### Vagrant Provisioner Script"

echo "### PWD:"
pwd

apt-get update
echo "### CURL"
apt-get -y install curl
echo "### PYTHON"
apt-get -y install python2.7
python --version

echo "### AWS CLI"
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
which pip
pip install awscli
aws --version
