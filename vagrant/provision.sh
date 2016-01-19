#!/bin/bash

echo "### Vagrant Provisioner Script"

echo "### PWD:$PWD"

apt-get update

echo "### CURL"
apt-get -y install curl

echo "### PYTHON"
apt-get -y install python2.7
python --version

echo "### JQ"
apt-get -y install jq
jq --version

echo "### AWS CLI"
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
which pip
pip install awscli
aws --version

echo "alias dpi='/vagrant/main.sh'" >> /home/vagrant/.bashrc
echo "Aliases added."

echo -e "\nPLEASE SET UP AN AWS ADMIN USER FIRST\nFor example: \"aws configure --profile dpi-admin\"\n"
