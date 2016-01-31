#!/bin/bash

echo "### AWS Deployment Pipeline Provisioner"

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

source $scriptdir/../../common/common.include

if [ "$#" -ne 0 ]; then
	echo "Error in arguments. No argument required. All variables are read from the creational state."
	exit 1
fi

source $stack_variables_file
source $scriptdir/stack.variables

echo "Init Jenkins user..."
node_variables_file="node.variables"
pwgen=$(pwgen -N 1)
echo "BUILD_NODE_USER=jenkins" > $node_variables_file
echo "BUILD_NODE_PASSWORD=$pwgen" >> $node_variables_file
cp $node_variables_file $scriptdir/build-node-java/
cp $node_variables_file $scriptdir/build-server/

echo "Provisioning the build node01..."
echo "${BUILDNODE01_NAME}" > $scriptdir/build-node-java/motd
ssh-keyscan -H $BUILD_NODE01_PUBLIC_DNS >> ~/.ssh/known_hosts
scp -i $ssh_key_file -rp $scriptdir/build-node-java $SSH_USER_NAME@$BUILD_NODE01_PUBLIC_DNS:~
ssh -i $ssh_key_file $SSH_USER_NAME@$BUILD_NODE01_PUBLIC_DNS "sudo ~/build-node-java/build-node-provision.sh"

echo "Provisioning the build server..."
echo "${BUILDSERVER_NAME}" > $scriptdir/build-server/motd
ssh-keyscan -H $BUILD_SERVER_PUBLIC_DNS >> ~/.ssh/known_hosts
scp -i $ssh_key_file -rp $scriptdir/build-server $SSH_USER_NAME@$BUILD_SERVER_PUBLIC_DNS:~
ssh -i $ssh_key_file $SSH_USER_NAME@$BUILD_SERVER_PUBLIC_DNS "sudo ~/build-server/build-server-provision.sh"

echo "Adding slaves ..."
# TODO: get default variables in nicely
source $scriptdir/build-node-java/default.variables
ssh -i $ssh_key_file $SSH_USER_NAME@$BUILD_SERVER_PUBLIC_DNS "sudo ~/build-server/add-node.sh $BUILDNODE01_NAME $DEFAULT_CREDENTIALS_ID \"$JENKINS_LABELS\" $BUILD_NODE01_PUBLIC_DNS"

echo "Restart Jenkins ..."
ssh -i $ssh_key_file $SSH_USER_NAME@$BUILD_SERVER_PUBLIC_DNS "sudo service jenkins restart"


echo "Jenkins is available at:"
echo "http://$BUILD_SERVER_PUBLIC_DNS/jenkins"
