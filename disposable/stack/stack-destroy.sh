#!/bin/bash

echo "### AWS Deployment Pipeline Infrastructure Destroy"

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

echo "Empty bucket..."
aws s3 rm s3://$AWS_BUCKET_NAME --recursive

echo "Delete stack..."
echo "AWS_STACK_STATUS=$AWS_STACK_STATUS"
aws cloudformation delete-stack --stack-name $AWS_STACK_NAME | tee delete-stack.response

echo "Please note that deletion is in progress. Status can be check with:"
echo "aws cloudformation describe-stacks --no-paginate --stack-name $AWS_STACK_NAME"
