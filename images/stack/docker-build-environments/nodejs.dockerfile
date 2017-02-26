FROM evarga/jenkins-slave

RUN apt-get update && apt-get -y install \
	software-properties-common \
	git \
	xorg-x11-server-Xvfb

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN npm install bower -g

RUN chsh -s /bin/bash jenkins

COPY java-env.sh /home/jenkins/.bashrc

