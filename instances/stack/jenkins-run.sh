#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

$scriptdir/docker-build-environments/docker-run.sh
$scriptdir/docker-build-environments/java-run.sh
$scriptdir/docker-build-environments/nodejs-run.sh
$scriptdir/docker-jenkins/jenkins-run.sh

