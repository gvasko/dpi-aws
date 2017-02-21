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

if ! validate_json $scriptdir ; then
	echo "ERROR: invalid json file, see above."
	exit 1
fi

source $stack_variables_file
source $scriptdir/stack.variables

stack_template_file="stack.json"

echo "Init stack tamplate..."
localfile="$scriptdir/$stack_template_file"
echo "localfile=$localfile"
s3file="s3://$AWS_BUCKET_NAME/$stack_template_file"
echo "s3file=$s3file"
aws s3 cp "$localfile" "$s3file"

AWS_STACK_NAME=${AWS_BASE_NAME//./-}


echo "Create stack..."
aws cloudformation create-stack --stack-name $AWS_STACK_NAME --template-url $AWS_BUCKET_URL/$stack_template_file --parameters ParameterKey=InstanceType,ParameterValue=$BUILD_SERVER_MTYPE ParameterKey=KeyName,ParameterValue=$AWS_SSH_KEY_NAME > create-stack.response

if [ $? -ne 0 ]; then
	echo "ERROR: stack creation failed. See the log above."
	echo "No destroy necessary."
	exit 1
fi

echo "Waiting for the stack..."
status="just started"
echo "status: $status"
while [ "X$status" != "XCREATE_COMPLETE" ]; do
	sleep 3
	aws cloudformation describe-stacks --no-paginate --stack-name $AWS_STACK_NAME > describe-stacks.response
	status=`cat describe-stacks.response | jq -r ".Stacks[] | select(.StackName == \"$AWS_STACK_NAME\") | .StackStatus"`
	echo "status: $status"
	if [ "X$status" = "XROLLBACK_COMPLETE" ]; then
		echo "status: $status, exiting"
		break
	fi
done

# TODO: export can add the same lines multiple times

echo "Exporting variables..."
echo "AWS_STACK_NAME=$AWS_STACK_NAME" >> $stack_variables_file
if [ "X$status" = "XCREATE_COMPLETE" ]; then
	echo "AWS_STACK_ID=$(cat create-stack.response | jq -r '.StackId')" >> $stack_variables_file
	
	buildserver_variables_file="${BUILDSERVER_NAME}.variables"
	buildserver_public_dns=`cat describe-stacks.response | jq -r ".Stacks[] | select(.StackName == \"$AWS_STACK_NAME\") | .Outputs[] | select(.OutputKey == \"BuildServerPublicDNS\") | .OutputValue"`
	echo "AWS_STACK_PUBLIC_DNS=$buildserver_public_dns" >> $buildserver_variables_file
	echo "BUILD_SERVER_PUBLIC_DNS=$buildserver_public_dns" >> $stack_variables_file
	
	buildnode01_variables_file="${BUILDNODE01_NAME}.variables"
	buildnode01_public_dns=`cat describe-stacks.response | jq -r ".Stacks[] | select(.StackName == \"$AWS_STACK_NAME\") | .Outputs[] | select(.OutputKey == \"BuildNode01PublicDNS\") | .OutputValue"`
	echo "AWS_STACK_PUBLIC_DNS=$buildnode01_public_dns" >> $buildnode01_variables_file
	echo "BUILD_NODE01_PUBLIC_DNS=$buildnode01_public_dns" >> $stack_variables_file
fi
echo "AWS_STACK_STATUS=$status" >> $stack_variables_file

$scriptdir/stack-provision.sh
