
yum update -y
yum install -y docker

DOCKER_OPTS='-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock'

service docker start

sed -i "s%\(^OPTIONS.\+\)\"$%\1 $DOCKER_OPTS\"%" /etc/sysconfig/docker

service docker restart

usermod -a -G docker ec2-user

echo "Log out and log back in again to pick up the new docker group permissions."
