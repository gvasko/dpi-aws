FROM evarga/jenkins-slave

RUN apt-get update && apt-get install -y --no-install-recommends \
	#linux-image-extra-$(uname -r) \
	linux-image-extra-virtual

RUN sudo apt-get install -y --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common

RUN curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -

RUN add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"

RUN apt-get update && apt-get -y install docker-engine

RUN usermod -a -G docker jenkins

RUN chsh -s /bin/bash jenkins

COPY dind-env.sh /home/jenkins/.bashrc

