#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

docker tag gvasko/jenkins-nodejs-node:latest $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-nodejs-node:latest
docker push $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-nodejs-node:latest

