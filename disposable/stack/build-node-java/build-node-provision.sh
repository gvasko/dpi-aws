#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

if [ $# -eq 1 ]; then
	scriptdir="$1"
fi

echo "scriptdir=$scriptdir"

node_variables_file="$scriptdir/node.variables"
system_profile="/etc/bash.bashrc"

source $node_variables_file

echo "# Install basic tools"
add-apt-repository -y ppa:openjdk-r/ppa
apt-add-repository -y ppa:natecarlson/maven3
apt-get update
apt-get install -y wget
apt-get install -y unzip

echo "# Create user jenkins"

jenkins_home="/var/$BUILD_NODE_USER"
adduser --quiet --home $jenkins_home --disabled-password --shell /bin/bash --gecos "User" $BUILD_NODE_USER
echo "$BUILD_NODE_USER:$BUILD_NODE_PASSWORD" | chpasswd
mkdir -p $jenkins_home
chown jenkins $jenkins_home
echo "export JENKINS_HOME=$jenkins_home/" >> $system_profile

echo "# Install java"
apt-get install -y openjdk-8-jdk

arch=$(dpkg --print-architecture)

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-$arch/" >> $system_profile

echo "# Install maven"
#apt-get install -y maven3
maven_version="3.3.9"
maven_name="apache-maven-${maven_version}"
maven_home_parent="/var/lib"
maven_home="${maven_home_parent}/${maven_name}"

maven_download_url="http://xenia.sote.hu/ftp/mirrors/www.apache.org/maven/maven-3/${maven_version}/binaries/${maven_name}-bin.zip"
maven_local_filename="${maven_name}-bin.zip"
wget $maven_download_url -O $maven_local_filename
unzip $maven_local_filename -d $maven_home_parent

echo "export PATH=$PATH:${maven_home}/bin" >> $system_profile

source $system_profile

mvn -v
