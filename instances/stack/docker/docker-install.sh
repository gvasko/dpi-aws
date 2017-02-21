
yum update -y
yum install -y docker
#echo "DOCKER_OPTS='-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock'" >> /etc/init/docker.conf
#TODO: /etc/sysconfig/docker and modify the OPTION varaible
service docker start
usermod -a -G docker ec2-user

echo "Log out and log back in again to pick up the new docker group permissions."
