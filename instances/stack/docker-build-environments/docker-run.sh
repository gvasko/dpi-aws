#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo
echo "########## DOCKER NODE ##########" 
echo

echo "scriptdir=$scriptdir"

. $scriptdir/../../../docker.variables

aws_access_key_id=$(cat ~/.aws/credentials | grep 'aws_access_key_id' | tr -d '[:space:]' | cut -d= -f2)
aws_secret_access_key=$(cat ~/.aws/credentials | grep 'aws_secret_access_key' | tr -d '[:space:]' | cut -d= -f2)

docker run -dt -e "AWS_ACCESS_KEY_ID=$aws_access_key_id" -e "AWS_SECRET_ACCESS_KEY=$aws_secret_access_key" -e "AWS_DEFAULT_REGION=eu-central-1" --name jenkins-docker-node-1 $DOCKER_PRIVATE_REGISTRY/gvasko/jenkins-docker-node

docker exec -u jenkins jenkins-docker-node-1 '/home/jenkins/docker-aws.sh'
docker exec -u jenkins jenkins-docker-node-1 'docker login -u AWS -p $(aws ecr get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2) -e none 221820444680.dkr.ecr.eu-central-1.amazonaws.com'

docker ps

