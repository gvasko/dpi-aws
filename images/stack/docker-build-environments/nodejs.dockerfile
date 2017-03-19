FROM 221820444680.dkr.ecr.eu-central-1.amazonaws.com/gvasko/jenkins-slave

RUN apt-get update && apt-get -y install \
	software-properties-common \
	wget \
	zip \
	unzip \
	git \
	curl

RUN curl --silent --location https://deb.nodesource.com/setup_6.x | bash
RUN apt-get install -y nodejs
RUN npm install bower -g
RUN npm install protractor -g

COPY nodejs-env.sh /home/jenkins/.bashrc

