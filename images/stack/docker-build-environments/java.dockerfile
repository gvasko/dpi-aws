FROM evarga/jenkins-slave

RUN apt-get update && apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y \ 
	wget \
	unzip \
	git \
	openjdk-8-jdk

COPY tmp/gradle-3.3-bin.zip /opt/
RUN mkdir /opt/gradle &&\
	unzip -d /opt/gradle /opt/gradle-3.3-bin.zip &&\
	rm /opt/gradle-3.3-bin.zip

RUN chsh -s /bin/bash jenkins

COPY java-env.sh /home/jenkins/.bashrc

