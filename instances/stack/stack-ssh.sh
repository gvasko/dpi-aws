#!/bin/bash

echo "### AWS Deployment Pipeline SSH Login"

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

source $scriptdir/../../common/common.include

if [ "$#" -ne 1 ]; then
	echo "Error in arguments. Instance name required."
	exit 1
fi

instance_name=$1

source $stack_variables_file
source $scriptdir/stack.variables

# Load the description of the given instance
instance_variables_file="$1.variables"
if [ ! -f "$instance_variables_file" ]; then
	echo "Error: no config was found for the given instance name."
	exit 1
fi
source $instance_variables_file

ssh -i $ssh_key_file $SSH_USER_NAME@$AWS_STACK_PUBLIC_DNS
