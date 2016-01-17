#!/bin/bash

echo "### AWS Deployment Pipeline SSH Login"

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

ssh -i $ssh_key_file $SSH_USER_NAME@$AWS_STACK_PUBLIC_DNS
