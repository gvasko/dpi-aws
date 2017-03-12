#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo
echo "########## JENKINS ##########"
echo

echo "scriptdir=$scriptdir"

source $scriptdir/common.include
source $scriptdir/../../../docker.variables

jenkins_home_dir=$scriptdir/jenkins_home

mkdir -p $jenkins_home_dir

docker run -dt -p 80:8080 -v $jenkins_home_dir:/var/jenkins_home:z --name jenkins $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins

docker ps

WaitForUrl http://localhost/login

initialAdminPassword=$jenkins_home_dir/secrets/initialAdminPassword

if [ -f $initialAdminPassword ]; then
	cat $initialAdminPassword
fi
