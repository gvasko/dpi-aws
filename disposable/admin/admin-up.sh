#!/bin/bash

echo "### AWS Admin Setup Script"

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

source $scriptdir/../../common/common.include
source $scriptdir/../../dpi.variables

if [ "$#" -ne 2 ]; then
	echo "Error in arguments."
	echo "Usage: $0 <name_postfix> <admin_profile_name>"
	exit 1
fi

name_postfix="$1"
admin_profile_name="$2"

basename="HU_GVASKO_DPI_${dpi_tag}_${name_postfix}"

echo "basename=$basename"

echo "Check if user $basename exists:"
users=`aws --profile $admin_profile_name iam list-users | jq -r '.[][].UserName'`
echo "Users: $users"

if [[ "$users" == *"$basename"* ]]; then
	echo "User $basename already defined."
	exit 1
fi

echo "Create user:"
aws --profile $admin_profile_name iam create-user --user-name $basename | tee create-user.response

echo "Create access key:"
aws --profile $admin_profile_name iam create-access-key --user-name $basename | tee create-access-key.response


