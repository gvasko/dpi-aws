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

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y openjdk-7-jdk
apt-get install -y jenkins

apt-get install -y nginx
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cp $scriptdir/nginx.config /etc/nginx/sites-available/jenkins
ln -nfs /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
mkdir -p /var/log/nginx/jenkins
service nginx restart

jenkins_args=$(cat /etc/default/jenkins | grep JENKINS_ARGS | sed -e 's:\"$: --prefix=/jenkins\":')
cat /etc/default/jenkins | grep -v JENKINS_ARGS > /etc/default/jenkins.new
echo $jenkins_args >> /etc/default/jenkins.new
mv /etc/default/jenkins.new /etc/default/jenkins

jenkins_home="/var/lib/jenkins"
jenkins_init_dir="$jenkins_home/init.groovy.d"
apt-get install -y unzip
$scriptdir/jenkins-plugins.sh $scriptdir/jenkins-plugins.txt
chown -R jenkins:jenkins $jenkins_home/plugins

cp $scriptdir/credentials.groovy $jenkins_init_dir/
cp $node_variables_file $jenkins_init_dir/

service jenkins restart
