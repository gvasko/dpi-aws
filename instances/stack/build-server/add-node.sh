#!/bin/bash

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

echo "scriptdir=$scriptdir"

if [ $# -ne 4 ]; then
	echo "Argument error. Required: <name> <credentials-id> <labels> <host>"
	exit 1
fi

node_name=$1
node_credentials=$2
node_labels=$3
node_url=$4

ssh-keyscan -H $node_url >> ~/.ssh/known_hosts

if [ "X$JENKINS_HOME" = "X" ]; then
	# TODO FIXME
	echo "WARNING! JENKINS_HOME not set. Using the default."
	export JENKINS_HOME="/var/lib/jenkins"
fi

node_dir="$JENKINS_HOME/nodes/$node_name"

mkdir -p $node_dir
cp $scriptdir/node-config-template.xml $node_dir/config.xml

name_token="@NAME@"
host_token="@HOST@"
credentials_token="@CREDENTIALS_ID@"
label_token="@LABEL@"

sed -i "s:$name_token:$node_name:" $node_dir/config.xml
sed -i "s:$host_token:$node_url:" $node_dir/config.xml
sed -i "s:$credentials_token:$node_credentials:" $node_dir/config.xml
sed -i "s:$label_token:$node_labels:" $node_dir/config.xml

chown -R jenkins:jenkins $node_dir

echo "Node $node_name added"
