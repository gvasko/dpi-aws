#!/bin/bash

echo "### AWS Deployment Pipeline Infrastructure Setup"

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

stack_template_file="infrastructure-stack.json"

echo "Init stack tamplate..."
localfile="$scriptdir/$stack_template_file"
echo "localfile=$localfile"
s3file="s3://$AWS_BUCKET_NAME/$stack_template_file"
echo "s3file=$s3file"
aws s3 cp "$localfile" "$s3file"

AWS_STACK_NAME=${AWS_BASE_NAME//./-}

# TODO: separate file
JENKINS_MTYPE="t2.micro"

echo "Create stack..."
aws cloudformation create-stack --stack-name $AWS_STACK_NAME --template-url $AWS_BUCKET_URL/$stack_template_file --parameters ParameterKey=InstanceType,ParameterValue=$JENKINS_MTYPE ParameterKey=KeyName,ParameterValue=$AWS_SSH_KEY_NAME | tee create-stack.response

echo "Waiting for the stack..."
status=""
while [ "X$status" != "XCREATE_COMPLETE" ]; do
	echo "."
	sleep 3
	aws cloudformation describe-stacks --no-paginate --stack-name $AWS_STACK_NAME > describe-stacks.response
	status=`cat describe-stacks.response | jq -r ".Stacks[] | select(.StackName == \"$AWS_STACK_NAME\") | .StackStatus"`
done

echo "Exporting variables..."
echo "AWS_STACK_NAME=$AWS_STACK_NAME" >> $stack_variables_file
echo "AWS_STACK_ID=$(cat create-stack.response | jq -r '.StackId')" >> $stack_variables_file
public_dns=`cat describe-stacks.response | jq -r ".Stacks[] | select(.StackName == \"$AWS_STACK_NAME\") | .Outputs[] | select(.OutputKey == \"PublicDNS\") | .OutputValue"`
echo "AWS_STACK_PUBLIC_DNS=$public_dns" >> $stack_variables_file

