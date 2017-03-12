#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

docker tag node:boron $DOCKER_PRIVATE_REGISTRY/nodejs/node:boron
docker push $DOCKER_PRIVATE_REGISTRY/nodejs/node:boron

