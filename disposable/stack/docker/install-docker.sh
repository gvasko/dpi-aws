
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user

echo "Log out and log back in again to pick up the new docker group permissions."
