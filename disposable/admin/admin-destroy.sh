#!/bin/bash

echo "### AWS Admin Destroy Script"

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

source $scriptdir/../../common/common.include
source $scriptdir/../../dpi.variables

if [ "$#" -ne 0 ]; then
	echo "Error in arguments. No argument required. All variables are read from the creational state."
	exit 1
fi

source admin.variables

echo "Delete bucket..."
aws --profile $admin_profile_name s3api delete-bucket --bucket $AWS_BUCKET_NAME --region $aws_region > delete-bucket.response

echo "Delete policy..."
aws --profile $admin_profile_name iam delete-user-policy --user-name $AWS_USER_NAME --policy-name $AWS_USER_POLICY_NAME > delete-user-policy.response

echo "Delete access key..."
aws --profile $admin_profile_name iam delete-access-key --user-name $AWS_USER_NAME --access-key-id $AWS_ACCESS_KEY_ID > delete-access-key.response

echo "Delete user..."
aws --profile $admin_profile_name iam delete-user --user-name $AWS_USER_NAME > delete-user.response

