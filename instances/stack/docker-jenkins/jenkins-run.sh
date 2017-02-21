#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

source $scriptdir/common.include

jenkins_home_dir=$scriptdir/jenkins_home

mkdir $jenkins_home_dir

uid=$(id -u)
gid=$(id -g)

docker pull $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-java-node
docker run -dt -p 80:8080 -v $scriptdir/$jenkins_home_dir:/var/jenkins_home:z --name jenkins --user $uid:$gid $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins

docker ps

WaitForUrl http://localhost/login

cat $jenkins_home_dir/secrets/initialAdminPassword

