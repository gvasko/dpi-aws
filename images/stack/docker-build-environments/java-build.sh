#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

gradle_zip="gradle-3.3-bin.zip"

tmp_dir=$scriptdir/tmp

if [ ! -f $tmp_dir/$gradle_zip ]; then
	mkdir -p $tmp_dir
	wget -O $tmp_dir/$gradle_zip https://services.gradle.org/distributions/$gradle_zip 
fi

docker build -f $scriptdir/java.dockerfile -t gvasko/jenkins-java-node:latest $scriptdir

