#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo
echo "########## NODEJS NODE ##########" 
echo

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

docker run -dt --name jenkins-nodejs-node-1 $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-nodejs-node
docker ps

