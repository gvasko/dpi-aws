#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo
echo "########## JAVA NODE 1 ##########" 
echo

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

docker pull $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-docker-node
docker run -dt --name jenkins-docker-node-1 $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-docker-node
docker ps

