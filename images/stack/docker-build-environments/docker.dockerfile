FROM 221820444680.dkr.ecr.eu-central-1.amazonaws.com/gvasko/jenkins-slave

# source: https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository

RUN apt-get update && \
	apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	jq \
	awscli

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \ 
	apt-get update && \
	apt-get install -y docker-ce

RUN usermod -a -G docker jenkins

COPY docker-env.sh /home/jenkins/.bashrc

COPY docker-aws.sh /home/jenkins/

