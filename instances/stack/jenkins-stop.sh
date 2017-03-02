#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

$scriptdir/docker-build-environments/docker-stop.sh
$scriptdir/docker-build-environments/java-stop.sh
$scriptdir/docker-build-environments/nodejs-stop.sh
$scriptdir/docker-jenkins/jenkins-stop.sh

