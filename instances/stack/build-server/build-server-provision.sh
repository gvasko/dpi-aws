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

source $scriptdir/common.include

system_profile="/etc/profile"

echo "# Pre-init..."
if [ -f "$scriptdir/node.variables" ]; then
	node_variables_file="$scriptdir/node.variables"
else
	echo "WARNING: node.variables not found, using vagrant-node.variables"
	node_variables_file="$scriptdir/vagrant-node.variables"
fi

echo "# Set welcome message..."
if [ ! -f "$scriptdir/motd" ]; then
	echo "instance of build-server" > $scriptdir/motd
fi
cp $scriptdir/motd /etc/

echo "# Install Jenkins..."
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y openjdk-7-jdk
apt-get install -y jenkins

WaitForUrl http://localhost/jenkins/log/

echo "# Install nginx..."
apt-get install -y nginx
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cp $scriptdir/nginx.config /etc/nginx/sites-available/jenkins
ln -nfs /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
mkdir -p /var/log/nginx/jenkins
service nginx restart

echo "# Configure Jenkins"
jenkins_args=$(cat /etc/default/jenkins | grep JENKINS_ARGS | sed -e 's:\"$: --prefix=/jenkins\":')
cat /etc/default/jenkins | grep -v JENKINS_ARGS > /etc/default/jenkins.new
echo $jenkins_args >> /etc/default/jenkins.new
mv /etc/default/jenkins.new /etc/default/jenkins

jenkins_home="/var/lib/jenkins"
echo "export JENKINS_HOME=$jenkins_home" >> $system_profile
jenkins_init_dir="$jenkins_home/init.groovy.d"
apt-get install -y unzip
$scriptdir/jenkins-plugins.sh $scriptdir/jenkins-plugins.txt
chown -R jenkins:jenkins $jenkins_home/plugins

mkdir -p $jenkins_init_dir
cp $scriptdir/credentials.groovy $jenkins_init_dir/
cp $node_variables_file $jenkins_init_dir/
chown -R jenkins:jenkins $jenkins_init_dir

service jenkins restart

WaitForUrl http://localhost/jenkins/log/

