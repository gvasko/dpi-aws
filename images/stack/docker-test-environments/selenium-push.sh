#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

docker tag selenium/standalone-chrome:latest $DOCKER_PRIVATE_REGISTRY/selenium/standalone-chrome:latest
docker push $DOCKER_PRIVATE_REGISTRY/selenium/standalone-chrome:latest

docker tag selenium/standalone-firefox:latest $DOCKER_PRIVATE_REGISTRY/selenium/standalone-firefox:latest
docker push $DOCKER_PRIVATE_REGISTRY/selenium/standalone-firefox:latest
