#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

if [ $# -eq 1 ]; then
	scriptdir="$1"
fi

echo "scriptdir=$scriptdir"

!!! server: ssh add slave to known hosts

node_dir="$JENKINS_HOME/nodes/$NODE_NAME"

mkdir -p $node_dir
cp $scriptdir/node-config-template.xml $node_dir/config.xml

name_token="@NAME@"
host_token="@HOST@"
credentials_token="@CREDENTIALS_ID@"
label_token="@LABEL@"

!!! sed all tokens

chown -R jenkins:jenkins $node_dir
