FROM evarga/jenkins-slave

RUN apt-get update && apt-get -y install \
	software-properties-common \
	wget \
	zip \
	unzip \
	git \
	curl

RUN curl --silent --location https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install bower -g
RUN npm install protractor -g

RUN chsh -s /bin/bash jenkins

COPY nodejs-env.sh /home/jenkins/.bashrc

