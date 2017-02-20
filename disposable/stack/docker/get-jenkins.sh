#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

source $scriptdir/common.include

docker pull jenkins

jenkins_home_dir="jenkins_home"

mkdir $jenkins_home_dir

uid=$(id -u)
gid=$(id -g)

docker run -dt -p 80:8080 -v $PWD/$jenkins_home_dir:/var/jenkins_home:z --name jenkins --user $uid:$gid jenkins

WaitForUrl http://localhost/login

cat $jenkins_home_dir/secrets/initialAdminPassword
