#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

docker build -f $scriptdir/dind.dockerfile -t gvasko/jenkins-dind-node:latest $scriptdir

