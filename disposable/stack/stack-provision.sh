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

echo "Provisioning the build server..."
ssh-keyscan -H $AWS_STACK_PUBLIC_DNS >> ~/.ssh/known_hosts
scp -i $ssh_key_file -rp "$scriptdir/build-server" $SSH_USER_NAME@$AWS_STACK_PUBLIC_DNS:~
ssh -i $ssh_key_file $SSH_USER_NAME@$AWS_STACK_PUBLIC_DNS "sudo ~/build-server/build-server-provision.sh"

echo "Jenkins is available at:"
echo "http://$AWS_STACK_PUBLIC_DNS/jenkins"