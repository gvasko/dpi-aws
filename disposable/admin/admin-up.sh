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

basename="hu.gvasko.dpi.${dpi_tag}.${name_postfix}"

echo "basename=$basename"

basename_lowercase=$(echo $basename | tr '[:upper:]' '[:lower:]')

AWS_USER_NAME=$basename
AWS_BUCKET_NAME=$basename_lowercase
AWS_USER_POLICY_NAME=$basename
AWS_SSH_KEY_NAME=$basename

echo "Check if user $basename exists..."
users=`aws --profile $admin_profile_name iam list-users | jq -r '.[][].UserName'`
echo "Users: $users"

if [[ "$users" == *"$basename"* ]]; then
	echo "User $basename already defined."
#	exit 1
fi

echo "Create user..."
aws --profile $admin_profile_name iam create-user --user-name $AWS_USER_NAME > create-user.response

echo "Create access key..."
aws --profile $admin_profile_name iam create-access-key --user-name $AWS_USER_NAME > create-access-key.response

echo "Create policy..."
aws --profile $admin_profile_name iam put-user-policy --user-name $AWS_USER_NAME --policy-name $AWS_USER_POLICY_NAME --policy-document "file://$scriptdir/admin-policy.json" > put-user-policy.response

echo "Create bucket..."
aws --profile $admin_profile_name s3api create-bucket --bucket $AWS_BUCKET_NAME --region $aws_region --create-bucket-configuration LocationConstraint=$aws_region > create-bucket.response

echo "Instantiating the template..."
json_user_name_token="@USER_NAME@"
json_bucket_name_token="@BUCKET_NAME@"

bucket_policy_file="bucket-policy.json"
cp $scriptdir/bucket-policy-template.json $bucket_policy_file
sed -i "s/$json_user_name_token/$basename/g" $bucket_policy_file
sed -i "s/$json_bucket_name_token/$basename/g" $bucket_policy_file

echo "Set bucket policy..."
aws --profile $admin_profile_name s3api put-bucket-policy --bucket $AWS_BUCKET_NAME --policy "file://$bucket_policy_file" --region $aws_region | tee put-bucket-policy.response

echo "Create SSH key pair..."
if [ -f "$ssh_key_file" ]; then
	chmod 600 $ssh_key_file
fi

aws --profile $admin_profile_name ec2 create-key-pair --key-name $AWS_SSH_KEY_NAME --query 'KeyMaterial' --output text --region $aws_region > $ssh_key_file
chmod 400 $ssh_key_file


echo "Export variables..."
echo "AWS_BASE_NAME=$basename" > $admin_variables_file
echo "AWS_USER_NAME=$AWS_USER_NAME" >> $admin_variables_file
echo "AWS_BUCKET_NAME=$AWS_BUCKET_NAME" >> $admin_variables_file
echo "AWS_USER_POLICY_NAME=$AWS_USER_POLICY_NAME" >> $admin_variables_file
AWS_USER_ID=$(cat create-user.response | jq -r '.User.UserId')
echo "AWS_USER_ID=$AWS_USER_ID" >> $admin_variables_file
AWS_ACCESS_KEY_ID=$(cat create-access-key.response | jq -r '.AccessKey.AccessKeyId')
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> $admin_variables_file
AWS_USER_SECRET_KEY=$(cat create-access-key.response | jq -r '.AccessKey.SecretAccessKey')
echo "AWS_USER_SECRET_KEY=$AWS_USER_SECRET_KEY" >> $admin_variables_file
echo "admin_profile_name=$admin_profile_name" >> $admin_variables_file
echo "AWS_SSH_KEY_NAME=$AWS_SSH_KEY_NAME" >> $admin_variables_file

echo "AWS_BASE_NAME=$basename" > $admin_variables_file
echo "AWS_BUCKET_NAME=$AWS_BUCKET_NAME" >> $stack_variables_file
echo "AWS_BUCKET_URL=https://s3.$aws_region.amazonaws.com/$AWS_BUCKET_NAME" >> $stack_variables_file
echo "AWS_SSH_KEY_NAME=$AWS_SSH_KEY_NAME" >> $stack_variables_file


echo "Configure AWS-CLI default user"
echo -e "\n[default]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_USER_SECRET_KEY\n" >> ~/.aws/credentials
echo -e "\n[default]\nregion = $aws_region\n" >> ~/.aws/config
