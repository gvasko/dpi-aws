#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

. $scriptdir/../../docker.variables

aws configure

token=$(aws ecr get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2)

docker login -u AWS -p $token -e none $DOCKER_PRIVATE_REGISTRY

